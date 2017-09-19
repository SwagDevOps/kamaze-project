# frozen_string_literal: true

require 'swag_dev/project/concern'
require 'active_support/concern'

# Provide access to ``mode`` (baed on environment ``PROJECT_MODE``)
module SwagDev::Project::Concern::Mode
  extend ActiveSupport::Concern

  # Get project mode
  #
  # @return [String]
  def mode
    (ENV['PROJECT_MODE'] || 'production').freeze
  end
end
