# frozen_string_literal: true

require 'swag_dev/project/concern'
require 'swag_dev/project/sham'

require 'active_support/concern'

# Provides a standardized way to use ``VersionInfo``
module SwagDev::Project::Concern::Sham
  extend ActiveSupport::Concern

  # Define a sham
  #
  # @param [Symbol] name
  # @return [nil]
  # @yieldreturn [Sham::Config]
  def sham
    SwagDev::Project::Sham
  end

  # Retrieve a sham
  #
  # @param [Symbol] name
  # @return [SwagDev::Project::Struct]
  def sham!(name, *args)
    sham.sham!(name, *args)
  end
end
