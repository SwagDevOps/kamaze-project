# frozen_string_literal: true

require_relative '../concern'

# Concern for CLI
#
# This module provides base methods focused on ``retcode``.
module SwagDev::Project::Concern::Cli

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
