# frozen_string_literal: true

require_relative '../concern'
require 'active_support/concern'

# Concern for CLI
#
# This module provides base methods focused on ``retcode``.
module SwagDev::Project::Concern::Cli
  extend ActiveSupport::Concern

  # @!attribute [r] retcode
  #   @return [Fixnum] retcode

  included do
    class_eval <<-"ACCESSORS", __FILE__, __LINE__ + 1
        protected

        attr_writer :retcode
    ACCESSORS
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
