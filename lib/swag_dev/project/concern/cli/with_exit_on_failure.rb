# frozen_string_literal: true

require_relative '../cli'

# Concern exit on failure
#
# Use ``retcode`` to exit in ``with_exit_on_failure`` blocks.
#
# @todo Add (rspec) test and examples
module SwagDev::Project::Concern::Cli::WithExitOnFailure
  include SwagDev::Project::Concern::Cli

  protected

  # Initiates termination by raising ``SystemExit`` exception
  # depending on ``success`` of given block.
  #
  # @yield [Object]
  # @yieldparam [self]
  #
  # @raise [SystemExit]
  # @return [Object]
  def with_exit_on_failure
    result = yield(self)

    exit(retcode) if failure?

    result
  end
end
