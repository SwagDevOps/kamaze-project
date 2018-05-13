# frozen_string_literal: true

require_relative '../concern'

# Concern for Sh
#
# This module provides a wrapper around ``Rake::FileUtilsExt.sh()``
module Kamaze::Project::Concern::Sh
  # @!attribute [rw] shell_runner_last_status
  #   @return [Process::Status]

  class << self
    def included(base)
      base.class_eval <<-"ACCESSORS", __FILE__, __LINE__ + 1
        protected

        attr_accessor :shell_runner_last_status

        attr_writer :shell_runner_debug
      ACCESSORS
    end
  end

  # Denote shell runner is in debug mode.
  #
  # @return [Boolean]
  def shell_runner_debug?
    @shell_runner_debug.nil? ? true : @shell_runner_debug
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
      self.shell_runner_last_status = status

      if !ok and shell_runner_debug?
        # rubocop:disable Layout/IndentHash
        warn("Command failed with status (%<retcode>s):\n# %<command>s" % {
               retcode: status.exitstatus,
               command: debug_cmd(cmd.clone).gsub(/\{\}$/, '')
             })
        # rubocop:enable Layout/IndentHash
      end
    end
  end

  # Print a debug message
  #
  # @param [Array] cmd
  # @return [String]
  def debug_cmd(cmd)
    options = cmd.last.is_a?(Hash) ? cmd.delete_at(-1) : {}

    '%<command>s' % {
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
