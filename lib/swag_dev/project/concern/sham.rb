# frozen_string_literal: true

require 'swag_dev/project/concern'
require 'swag_dev/project/sham'

require 'active_support/concern'

# Provides a standardized way to retrieve shams
#
# @see SwagDev::Project::Sham
module SwagDev::Project::Concern::Sham
  extend ActiveSupport::Concern

  # Define a sham
  #
  # @param [Symbol] name
  # @return [nil]
  # @yieldreturn [Sham::Config]
  def sham(name, *args)
    sham_class.sham!(name, *args)
  end

  # Retrieve a sham
  #
  # @param [Symbol] name
  # @return [SwagDev::Project::Struct]
  def sham!(name, *args)
    sham_class.sham!(name, *args)
  end

  # Get
  def sham_class
    SwagDev::Project::Sham
  end
end
