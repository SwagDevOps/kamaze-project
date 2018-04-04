# frozen_string_literal: true

require_relative '../tools'
require_relative 'base_tool'
require 'pathname'
require 'yard'

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

  # Options used by ``YARD::CLI::Yardoc``
  #
  # @type [Hash]
  # @return [Hash]
  attr_accessor :options

  # @return [Fixnum]
  def run
    retcode = core.run
    retcode = retcode ? 0 : 1 if [true, false].include?(retcode)

    retcode
  end

  # Get output directory (default SHOULD be ``doc``)
  #
  # @return [Pathname]
  def output_dir
    core.options
        .yield_self(&:serializer)
        .yield_self(&:basepath).gsub(%r{^\./+}, '')
        .yield_self { |path| ::Pathname.new(path) }
  end

  alias call run

  def mutable_attributes
    [:options]
  end

  protected

  def setup
    @options ||= {}
  end

  # @return [YARD::CLI::Yardoc]
  def core
    YARD::CLI::Yardoc.new.tap do |yard|
      yard.parse_arguments([])

      options.to_h.each { |k, v| yard.options[k.to_sym] = v }
    end
  end
end
