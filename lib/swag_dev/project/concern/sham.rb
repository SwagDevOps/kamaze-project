# frozen_string_literal: true

require 'swag_dev/project/concern'
require 'swag_dev/project/sham'

require 'active_support/concern'
require 'sham'

# Provides a standardized way to define and retrieve shams
#
# @see SwagDev::Project::Sham
module SwagDev::Project::Concern::Sham
  extend ActiveSupport::Concern

  # Define/Retrieve a sham
  #
  # Define a sham when a block is given,
  # or retrieve a sham by its name.
  # Return nil when retrieving and sham is not already defined.
  #
  # @param [Symbol] name
  # @yieldreturn [Sham::Config]
  # @return [self|SwagDev::Project::Struct|nil]
  def sham(name, *args)
    name = name.to_sym

    return shammer.sham(name, *args) unless block_given?

    shammable = shammer.config(name).shammable
    yield(Sham::Config.new(shammable, name))

    self
  end

  # Retrieve a sham
  #
  # @raise [ArgumentError]
  # @param [Symbol] name
  # @return [SwagDev::Project::Struct]
  def sham!(name, *args)
    name = name.to_sym

    shammer.sham!(name, *args)
  end

  protected

  # Get ``Sham`` class
  #
  # @return [SwagDev::Project::Sham]
  def shammer
    SwagDev::Project::Sham
  end
end
