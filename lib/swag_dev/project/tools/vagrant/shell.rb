# frozen_string_literal: true

require_relative '../vagrant'
require_relative '../../concern/cli/with_exit_on_failure'
require_relative '../../concern/sh'
require 'pathname'
require 'shellwords'

class SwagDev::Project::Tools::Vagrant
  class Shell
  end
end

# Execute commands using ``executable``
#
# Options are passed to ``Rake::FileUtilsExt.sh()``.
# Executable can be defined through ``options``.
class SwagDev::Project::Tools::Vagrant::Shell
  include SwagDev::Project::Concern::Cli::WithExitOnFailure
  include SwagDev::Project::Concern::Sh

  # @return [Hash]
  attr_reader :options

  # Initialize a shell with given options
  #
  # @param [Hash] options
  def initialize(options = {})
    @options = options
    # Executable used by command
    @executable = options.delete(:executable) || :vagrant

    # default ``sh`` options
    @options[:verbose] = false unless options.key?(:verbose)
  end

  # @return [Boolean]
  def executable?
    executable
  end

  # Get (absolute) path to executable
  #
  # Return ``nil`` when executable CAN NOT be detected.
  #
  # @return [String|nil]
  def executable
    Cliver.detect(@executable)&.freeze
  end

  # @return [Array]
  def to_a
    [executable]
  end

  # @return [String]
  def to_s
    executable.to_s
  end

  # Run given arguments as system command using ``executable``.
  def execute(*params, &block)
    env = preserved_env

    Bundler.with_clean_env do
      with_exit_on_failure do
        [env].concat(to_a.concat(params)).push(options).yield_self do |cmd|
          sh(*cmd, &block)

          self.retcode = self.shell_runner_last_status.exitstatus
        end
      end
    end
  end

  protected

  # Get preserved env (from given env)
  #
  # @param [ENV|Hash] from
  # @return [Hash]
  #
  # @todo refactor
  def preserved_env(from = ENV)
    env = {}
    from = from.to_h

    ['SILENCE_DUPLICATE_DIRECTORY_ERRORS'].each do |key|
      next unless from.key?(key)

      env[key] = from.fetch(key)
    end

    env
  end
end
