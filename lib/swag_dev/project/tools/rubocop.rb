# frozen_string_literal: true

require_relative '../tools'
require_relative 'base_tool'
require 'pathname'
require 'rubocop'

# rubocop:disable Style/Documentation
class SwagDev::Project::Tools
  class Rubocop < BaseTool
    class Arguments < Array
      require_relative 'rubocop/arguments'
    end
  end
end
# rubocop:enable Style/Documentation

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
  # @type [Array|Arguments]
  # @return [Arguments]
  attr_accessor :defaults

  # @type [Boolean]
  # @return [Boolean]
  attr_accessor :fail_on_error

  def mutable_attributes
    [:defaults, :fail_on_error]
  end

  def prepare
    # @todo Use a real class instead of ``OpenStruct``
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

  # Arguments used by ``CLI`` (during execution/``run``)
  #
  # @return [Arguments]
  def arguments
    @arguments = defaults.clone if @arguments.to_a.size.zero?

    if caller_locations(1..1).first.path == __FILE__
      @arguments
    else
      @arguments.clone.freeze
    end
  end

  def run
    prepare if arguments.to_a.empty?

    retcode = core.run(arguments.to_a)

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
    @defaults = Arguments.new(@defaults.to_a)
    @fail_on_error = true if @fail_on_error.nil?
  end

  # Match against given patterns
  #
  # @param [Array<String>] patterns
  # @return [Array<String>]
  def match_patterns(patterns)
    Dir.glob(patterns)
  end

  # Abort execution on error
  #
  # @param [Fixnum] code
  # @return [Fixnum]
  def on_error(code)
    (exit(code) if fail_on_error?) unless code.zero?

    code
  end

  # @return [YARD::CLI::Yardoc]
  def core
    RuboCop::CLI.new
  end
end
