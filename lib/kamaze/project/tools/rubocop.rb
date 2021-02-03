# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../tools'

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
class Kamaze::Project::Tools::Rubocop < Kamaze::Project::Tools::BaseTool
  # @formatter:off
  {
    Arguments: 'arguments',
    Config: 'config',
  }.each { |s, fp| autoload(s, "#{__dir__}/rubocop/#{fp}") }
  # @formatter:on

  autoload(:Pathname, 'pathname')
  autoload(:RuboCop, 'rubocop')

  include Kamaze::Project::Concern::Cli::WithExitOnFailure

  # Default arguments used by ``Rubocop::CLI``
  #
  # @type [Array|Arguments]
  # @return [Arguments]
  attr_accessor :defaults

  def mutable_attributes
    [:defaults]
  end

  def prepare
    self.tap do
      reset

      if block_given?
        Config.new.tap do |config|
          yield(config)
          arguments.concat(config.freeze.to_a)
        end
      end

      arguments.freeze
    end
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

  # @raise [SystemExit]
  # @return [self]
  def run
    prepare if arguments.to_a.empty?

    if runnable?
      with_exit_on_failure do
        core.run(arguments.to_a).tap { |retcode| self.retcode = retcode }
        reset
      end
    end

    self
  end

  protected

  attr_writer :arguments

  def setup
    @defaults = Arguments.new((@defaults || ['--only-recognized-file-types']).to_a)
  end

  # Reset arguments + retcode
  #
  # @return [self]
  def reset
    self.tap do
      @arguments = nil
      self.retcode = nil if retcode.to_i.zero?
    end
  end

  # @return [RuboCop::CLI]
  def core
    RuboCop::CLI.new
  end
end
