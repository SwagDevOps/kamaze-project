# frozen_string_literal: true

require_relative '../tools'
require_relative 'base_tool'
require 'pathname'
require 'yard'

class SwagDev::Project::Tools
  class Yardoc < BaseTool
  end
end

# Tool to run ``CLI::Yardoc`` and generate documentation
#
# @see https://github.com/lsegal/yard/blob/49d885f29075cfef4cb954bb9247b6fbc8318cac/lib/yard/rake/yardoc_task.rb
class SwagDev::Project::Tools::Yardoc
  # @type [Hash]
  # @return [Hash]
  attr_accessor :options

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

  # Get paths (based on ``YARD::CLI::Yardoc#files``)
  #
  # @return [Array<Pathname>]
  def paths
    core.files.to_a.flatten.map do |file|
      Dir.glob(file).map do |f|
        f.gsub!('./', '')

        ::Pathname.new(f).dirname
      end.uniq.sort[0]
    end.flatten.uniq.sort
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
  end

  # @return [YARD::CLI::Yardoc]
  def core
    yard = YARD::CLI::Yardoc.new
    yard.parse_arguments([])
    options.to_h.each { |k, v| yard.options[k.to_sym] = v }

    yard
  end
end
