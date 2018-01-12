# frozen_string_literal: true

require_relative '../tools'
require_relative 'base_tool'
require 'pathname'
require 'rubocop'

class SwagDev::Project::Tools
  class Rubocop < BaseTool
  end
end

# Tool to run ``Rubocop::CLI``
class SwagDev::Project::Tools::Rubocop
  # Default arguments used by ``Rubocop::CLI``
  #
  # @type [Array<String>]
  # @return [Array<String>]
  attr_reader :defaults

  # Arguments used by ``Rubocop::CLI``
  #
  # @type [String|Pathname]
  # @return [Pathname]
  attr_accessor :config_file

  def run(args, options = {})
    args = arguments.push(*args)
    if options[:patterns]
      match_patterns(options[:patterns]).tap do |files|
        args = args.push(*files)
      end
    end

    core.run(args)
  end

  # Denote configurable
  #
  # @return [Boolean]
  def configurable?
    config_file.file? and config_file.readable?
  end

  # Arguments used by CLI
  #
  # @return [Array<String>]
  def arguments
    configurable? ? arguments_push('-c', config_file) : []
  end

  protected

  def setup
    @defaults ||= []
    @config_file = ::Pathname.new(@config_file || "#{Dir.pwd}/.rubocop.yml")
  end

  # @param [Array<Object>] args
  # @return [Array<String>]
  def arguments_push(*args)
    defaults.clone.to_a.push(*args).map(&:to_s)
  end

  # Match against given patterns
  #
  # @param [Array<String>] patterns
  # @return [Array<String>]
  def match_patterns(patterns)
    files = Dir.glob(patterns)
    # raise "#{patterns} does not match any files" if files.empty?

    files
  end

  # @return [YARD::CLI::Yardoc]
  def core
    RuboCop::CLI.new
  end
end
