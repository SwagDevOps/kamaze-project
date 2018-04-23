# frozen_string_literal: true

require_relative '../tools'
require_relative '../concern/cli/with_exit_on_failure'
require 'pathname'
require 'rubocop'

# rubocop:disable Style/Documentation

module SwagDev::Project::Tools
  class Rubocop < BaseTool
    class Arguments < Array
      require_relative 'rubocop/arguments'
    end

    class Config
      require_relative 'rubocop/config'
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
  include SwagDev::Project::Concern::Cli::WithExitOnFailure

  # Default arguments used by ``Rubocop::CLI``
  #
  # @type [Array|Arguments]
  # @return [Arguments]
  attr_accessor :defaults

  def mutable_attributes
    [:defaults]
  end

  def prepare
    reset

    if block_given?
      config = Config.new
      yield(config)
      arguments.concat(config.freeze.to_a)
    end

    arguments.freeze

    self
  end

  # Reset arguments + retcode
  #
  # @return [self]
  def reset
    @arguments = nil
    self.retcode = nil

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

  # Denote runnable
  #
  # When last argument is ``--`` we suppose there is no files
  #
  # @return [Boolean]
  def runnable?
    '--' != arguments.last
  end

  # @return [self]
  def run
    prepare if arguments.to_a.empty?

    with_exit_on_failure do
      if runnable?
        self.retcode = core.run(arguments.to_a)

        reset
      end
    end

    self
  end

  protected

  attr_writer :arguments

  def setup
    @defaults = Arguments.new(@defaults.to_a)
  end

  # @return [YARD::CLI::Yardoc]
  def core
    RuboCop::CLI.new
  end
end
