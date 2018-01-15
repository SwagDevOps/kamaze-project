# frozen_string_literal: true

require_relative '../tools'
require_relative 'base_tool'
require 'pathname'
require 'rubocop'

class SwagDev::Project::Tools
  class Rubocop < BaseTool
  end

  class Rubocop::Arguments < Array
  end
end

# Tool to run ``Rubocop::CLI``
#
# Sample of use:
#
# ```ruby
# Rubocop.new.prepare do |c|
#   c.patterns = ["#{Dir.pwd}/test/cs.rb"]
#   c.options = ['--fail-level', 'E']
# end.run
# ```
class SwagDev::Project::Tools::Rubocop
  # Default arguments used by ``Rubocop::CLI``
  #
  # @type [Array<String>]
  # @return [Array<String>]
  attr_accessor :defaults

  # Arguments used by ``Rubocop::CLI``
  #
  # @type [String|Pathname]
  # @return [Pathname]
  attr_accessor :config_file

  attr_accessor :fail_on_error

  def prepare
    config = OpenStruct.new
    yield(config) if block_given?

    reset.arguments.concat(config.options.to_a)
    if config.patterns
      match_patterns(config.patterns).tap do |files|
        arguments.concat(files)
      end
    end

    arguments.freeze

    self
  end

  # Reset arguments
  #
  # @return [self]
  def reset
    @arguments = nil

    self
  end

  # Arguments used by CLI
  #
  # @return [Array<String>]
  def arguments
    @arguments = defaults.clone if @arguments.to_a.size.zero?

    @arguments
  end

  def run
    prepare if arguments.to_a.empty?

    retcode = core.run(arguments)

    reset.on_error(retcode)
  end

  # Denote configurable
  #
  # @return [Boolean]
  def configurable?
    config_file.file? and config_file.readable?
  end

  def fail_on_error?
    !!@fail_on_error
  end

  protected

  attr_writer :arguments

  def setup
    @config_file = ::Pathname.new(config_file || "#{Dir.pwd}/.rubocop.yml")
    @defaults ||= Arguments.new(['-c', config_file])
    @fail_on_error = true if @fail_on_error.nil?
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

  def on_error(code)
    exit(code) if fail_on_error? and code != 0

    code
  end

  # @return [YARD::CLI::Yardoc]
  def core
    RuboCop::CLI.new
  end
end
