# frozen_string_literal: true

require_relative '../yardoc'

class SwagDev::Project::Tools::Yardoc
  class Watcher < SwagDev::Project::Tools::BaseTool
  end
end

# Provide a watcher built on top of Yardoc
class SwagDev::Project::Tools::Yardoc::Watcher
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
    require_relative 'watcher/_bootstrap'

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
      only:   /\.rb|md$/,
      ignore: yardoc.excluded.map { |pattern| /#{pattern}/ }
    }.merge(@options.to_h)
  end

  # @return [SwagDev::Project::Tools::Yardoc]
  def yardoc
    SwagDev.project.tools.fetch('yardoc')
  end
end
