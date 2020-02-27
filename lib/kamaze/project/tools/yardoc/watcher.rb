# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../yardoc'

class Kamaze::Project::Tools::Yardoc
  class Watcher < Kamaze::Project::Tools::BaseTool
  end
end

# Provide a watcher built on top of Yardoc
class Kamaze::Project::Tools::Yardoc::Watcher
  # @type [Array<String>]
  attr_writer :paths

  # @type [Hash]
  attr_accessor :options

  # @type [Array<String>]
  attr_writer :patterns

  # Watch for changes
  #
  # Non-blocking, unless ``wait``
  #
  # @param [Boolean] wait
  # @return [self]
  def watch(wait = false)
    listener = ::Listen.to(*paths, options) do |mod, add, rem|
      if trigger?(mod + add + rem)
        yardoc.run
      end
    end

    listener.start
    sleep if wait

    self
  end

  # @return [Array<String>]
  def patterns
    @patterns.map { |pattern| pattern.gsub(%r{^./+}, '') }
  end

  # @return [Array<String>]
  def paths
    paths = @paths.map(&:to_s)

    paths.include?('.') ? ['.'] : paths
  end

  def mutable_attributes
    [:paths, :options, :patterns]
  end

  protected

  # Transform paths to relative paths
  #
  # @param [String|Pathname|Array<String>] paths
  def rel(paths)
    paths = [paths] unless paths.is_a?(Array)

    paths.map do |path|
      path.to_s.gsub(%r{^#{Dir.pwd}/+}, '')
    end
  end

  # Denote paths trigger (require) action
  #
  # @param [String|Pathname|Array<String>] paths
  # @return [Boolean]
  def trigger?(paths)
    paths = [paths] unless paths.is_a?(Array)

    paths.map(&:to_s)
         .map { |path| rel(path)[0] }
         .each do |path|
      patterns.each do |pattern|
        return true if File.fnmatch(pattern, path, File::FNM_PATHNAME)
      end
    end

    false
  end

  def setup
    @paths ||= yardoc.paths
    @patterns ||= yardoc.patterns
    @options = {
      only:   /\.(rb|md)$/,
      ignore: yardoc.excluded.map { |pattern| /#{pattern}/ }
    }.merge(@options.to_h)
  end

  # @return [Kamaze::Project::Tools::Yardoc]
  def yardoc
    Kamaze.project.tools.fetch('yardoc')
  end
end
