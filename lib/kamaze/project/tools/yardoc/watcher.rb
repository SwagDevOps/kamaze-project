# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../yardoc'

# Provide a watcher built on top of Yardoc
class Kamaze::Project::Tools::Yardoc::Watcher < Kamaze::Project::Tools::BaseTool
  autoload(:Listen, 'listen')

  # @return [Kamaze::Project::Tools::Yardoc]
  attr_accessor :yardoc

  # @type [Array<String>]
  attr_writer :paths

  # @type [Hash]
  attr_accessor :options

  # @type [Array<String>]
  attr_writer :patterns

  # Watch for changes
  #
  # Non-blocking, unless ``wait`` (bool)
  #
  # @param [Boolean] wait
  # @return [self]
  def watch(wait = false)
    self.tap do
      Listen.to(*paths, options) do |mod, add, rem|
        yardoc.run if trigger?(*mod.concat(add).concat(rem))
      end.tap(&:start)

      sleep if wait
    end
  end

  # @return [Array<String>]
  def patterns
    @patterns.map { |pattern| pattern.gsub(%r{^./+}, '') }
  end

  # @return [Array<String>]
  def paths
    @paths.map(&:to_s).tap do |paths|
      return paths.include?('.') ? ['.'] : paths
    end
  end

  def mutable_attributes
    [:yardoc, :paths, :options, :patterns]
  end

  protected

  # Transform paths to relative paths
  #
  # @param [String|Pathname|Array<String>] paths
  def relative(*paths)
    (paths.is_a?(Array) ? paths : [paths]).map do |path|
      path.to_s.gsub(%r{^#{Dir.pwd}/+}, '')
    end
  end

  # Denote paths trigger (require) action
  #
  # @param [String|Pathname|Array<String>] paths
  # @return [Boolean]
  def trigger?(*paths)
    # @formatter:off
    paths.map(&:to_s)
         .map { |path| relative(path)[0] }
         .each do |path|
      patterns.each do |pattern|
        return true if File.fnmatch(pattern, path, File::FNM_PATHNAME)
      end
      # @formatter:on
    end

    false
  end

  def setup
    @yardoc ||= Kamaze::Project.instance.tools.fetch('yardoc')
    @paths ||= yardoc.paths
    @patterns ||= yardoc.patterns
    # @formatter:off
    @options = {
      only: /\.(rb|md)$/,
      ignore: yardoc.excluded.map { |pattern| /#{pattern}/ }
    }.merge(@options.to_h)
    # @formatter:on
  end
end
