# frozen_string_literal: true

require_relative '../vagrant'
require 'pathname'

class SwagDev::Project::Tools::Vagrant
  class Shell
  end
end

# Execute commands using ``executable``
#
# Options are passed to ``Rake::FileUtilsExt.sh()``.
# Executable can be defined through ``options``.
class SwagDev::Project::Tools::Vagrant::Shell
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
    Bundler.with_clean_env do
      # [ENV.to_h]
      sh(*to_a.concat(params), &block)
    end
  end

  protected

  # Run given (``cmd``) system command.
  #
  # If multiple arguments are given the command is run directly
  # (without the shell, same semantics as Kernel::exec and Kernel::system).
  #
  # @see [Rake::FileUtilsExt]
  # @see https://github.com/ruby/rake/blob/68ef9140c11d083d8bb7ee5da5b0543e3a7df73d/lib/rake/file_utils.rb#L44
  def sh(*cmd, &block)
    require 'rake'
    require 'rake/file_utils'

    unless cmd.last.is_a?(Hash) and !cmd.last.empty?
      cmd.push(options.clone)
    end

    ::Rake::FileUtilsExt.sh(*cmd, &block)
  end
end
