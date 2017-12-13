# frozen_string_literal: true

require_relative '../tools'
require_relative 'base_tool'
require 'pathname'
require 'yard'
require 'logger'

# rubocop:disable Style/Documentation

class SwagDev::Project::Tools
  class Yardoc < BaseTool
  end

  require_relative 'yardoc/file'
end

# rubocop:enable Style/Documentation

# Tool to run ``CLI::Yardoc`` and generate documentation
#
# @see https://github.com/lsegal/yard/blob/49d885f29075cfef4cb954bb9247b6fbc8318cac/lib/yard/rake/yardoc_task.rb
class SwagDev::Project::Tools::Yardoc
  # @type [Hash]
  # @return [Hash]
  attr_accessor :options

  # @type [Fixnum]
  # @return [Fixnum]
  attr_accessor :log_level

  def run
    core.run
  end

  # The output directory. (defaults to ``./doc``)
  #
  # @return [Pathname]
  def output_dir
    path = core.options.serializer.basepath.gsub(%r{^\./+}, '')

    ::Pathname.new(path)
  end

  # Get paths
  #
  # @return [Array<Pathname>]
  def paths
    files.map do |file|
      file.to_a.sort[0]
    end.flatten.compact.uniq.sort
  end

  # Get files
  #
  # Mostly patterns,
  # addition of ``files`` with ``options.files``
  # SHOULD include ``README`` file, when ``.yardopts`` defined
  #
  # @return [Array<SwagDev::Project::Tools::Yardoc::File>]
  def files
    [
      core.files.to_a.flatten.map { |f| File.new(f, true) },
      core.options.files.to_a.map { |f| File.new(f.filename, false) }
    ].flatten
  end

  # Ignores files matching path match (regexp)
  #
  # @return [Array<String>]
  def excluded
    core.excluded
  end

  alias call run

  protected

  def setup
    @options ||= {}
    @log_level ||= Logger::ERROR
  end

  # @return [YARD::CLI::Yardoc]
  def core
    yard = YARD::CLI::Yardoc.new
    yard.__send__(:log).level = Logger::ERROR if yard.respond_to?(:log, true)

    yard.parse_arguments([])
    options.to_h.each { |k, v| yard.options[k.to_sym] = v }

    yard
  end
end
