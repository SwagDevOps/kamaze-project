# frozen_string_literal: true

require_relative '../concern'
require 'active_support/concern'

# Concern for CLI
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

  # @return [Fixnum]
  def retcode
    @retcode ||= 0
  end

  # Denote execution is a success.
  #
  # @return [Boolean]
  def success?
    retcode.zero?
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