# frozen_string_literal: true

require_relative '../concern'

# Provide access to ``mode`` (baed on environment ``PROJECT_MODE``)
module Kamaze::Project::Concern::Mode
  # Get project mode
  #
  # @return [String]
  def mode
    (ENV['PROJECT_MODE'] || 'production').freeze
  end
end
