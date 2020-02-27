# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../cli'

# Concern exit on failure
#
# Use ``retcode`` to exit in ``with_exit_on_failure`` blocks.
#
# @todo Add (rspec) test and examples
module Kamaze::Project::Concern::Cli::WithExitOnFailure
  include Kamaze::Project::Concern::Cli

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
