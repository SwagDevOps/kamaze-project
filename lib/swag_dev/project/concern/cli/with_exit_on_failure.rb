# frozen_string_literal: true

require_relative '../cli'

# Concern exit on failure
#
# Use ``retcode`` to exit in ``with_exit_on_failure`` blocks.
module SwagDev::Project::Concern::Cli::WithExitOnFailure
  include SwagDev::Project::Concern::Cli

  # Denote program SOULD exit in ``with_exit_on_failure`` blocks.
  #
  # @return [Boolean]
  def exit_on_failure?
    !!@exit_on_failure
  end

  protected

  attr_writer :exit_on_failure

  # Initiates termination by raising ``SystemExit`` exception
  # depending on ``success`` of given block.
  #
  # @yield [Object]
  # @yieldparam [self]
  #
  # @return [Object]
  def with_exit_on_failure
    result = yield(self)

    exit(retcode) if exit_on_failure? and failure?

    result
  end
end
