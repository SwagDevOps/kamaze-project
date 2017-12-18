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
  require_relative 'yardoc/watchable'
end

# rubocop:enable Style/Documentation

# Tool to run ``CLI::Yardoc`` and generate documentation
#
# @see https://github.com/lsegal/yard/blob/49d885f29075cfef4cb954bb9247b6fbc8318cac/lib/yard/rake/yardoc_task.rb
class SwagDev::Project::Tools::Yardoc
  include Watchable

  # Options used by {YARD::CLI::Yardoc}
  #
  # @type [Hash]
  # @return [Hash]
  attr_accessor :options

  # @type [Fixnum]
  # @return [Fixnum]
  attr_accessor :log_level

  # Options to pass to {YARD::CLI::Stats}
  #
  # @return [Array<String>] the options passed to the stats utility
  attr_accessor :stats_options

  def run
    core.run('--no-stats')
    YARD::CLI::Stats.run(*stats_options)
  end

  # Get output directory (default SHOULD be ``doc``)
  #
  # @return [Pathname]
  def output_dir
    path = core.options.serializer.basepath.gsub(%r{^\./+}, '')

    ::Pathname.new(path)
  end

  alias call run

  protected

  def setup
    @options ||= {}
    @log_level ||= Logger::ERROR
    @stats_options ||= (@stats_options || []) + ['--use-cache']
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
