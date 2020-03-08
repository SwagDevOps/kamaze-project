# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../concern'

# Concern for CLI
#
# This module provides base methods focused on ``retcode``.
module Kamaze::Project::Concern::Cli
  autoload(:WithExitOnFailure, "#{__dir__}/cli/with_exit_on_failure")

  # @!attribute [r] retcode
  #   @return [Fixnum] retcode

  class << self
    def included(base)
      base.class_eval <<-"ACCESSORS", __FILE__, __LINE__ + 1
        protected

        attr_writer :retcode
      ACCESSORS
    end
  end

  # Status code usable to eventually initiates the termination.
  #
  # @return [Fixnum]
  def retcode
    @retcode || Errno::NOERROR::Errno
  end

  # Denote execution is a success.
  #
  # @return [Boolean]
  def success?
    # noinspection RubyResolve
    Errno::NOERROR::Errno == retcode
  end

  # Denote execution is a failure.
  #
  # @return [Boolean]
  def failure?
    !success?
  end

  alias failed? failure?

  alias successful? success?
end
