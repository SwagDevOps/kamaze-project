# frozen_string_literal: true

require_relative '../concern'
require 'active_support/concern'

# Concern for Sh
#
# This module provides a wrapper around ``Rake::FileUtilsExt.sh()``
module SwagDev::Project::Concern::Sh
  extend ActiveSupport::Concern

  # @!attribute [r] last_shell_runner_status
  #   @return [Process::Status] last_shell_runner_status

  included do
    class_eval <<-"ACCESSORS", __FILE__, __LINE__ + 1
        protected

        attr_writer :last_shell_runner_status
    ACCESSORS
  end

  # Status code usable to eventually initiates the termination.
  #
  # @return [Process::Status|nil]
  def last_shell_runner_status
    @last_shell_runner_status
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

    block ||= create_shell_runner(cmd)

    ::Rake::FileUtilsExt.sh(*cmd, &block)
  end

  # Get shell block
  #
  # @param [Array] cmd
  # @return [Proc]
  def create_shell_runner(cmd)
    proc do |ok, status|
      self.last_shell_runner_status = status

      unless ok
        command = debug_cmd(cmd.clone)

        warn("Command failed with status (#{retcode}):\n#{command}")
      end
    end
  end

  # Print a debug message
  #
  # @param [Array] cmd
  # @return [String]
  def debug_cmd(cmd)
    options = cmd.last.is_a?(Hash) ? cmd.delete_at(-1) : {}

    '# %<command>s' % {
      command: [
        (cmd[0].is_a?(Hash) ? cmd.delete_at(0) : {}).to_a.map do |v|
          "#{v[0]}=#{Shellwords.shellescape(v[1])}"
        end.join(' '),
        Shellwords.shelljoin(cmd),
        options
      ].join(' ')
    }
  end
end
