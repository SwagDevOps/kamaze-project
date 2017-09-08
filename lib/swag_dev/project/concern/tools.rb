# frozen_string_literal: true

require 'swag_dev/project/concern'
require 'swag_dev/project/tools'
require 'active_support/concern'

# Provides access to tools
#
# Tools provide an extensibility mechanism
module SwagDev::Project::Concern::Tools
  extend ActiveSupport::Concern

  # Get tools
  #
  # @return [Hash]
  def tools
    @tools ||= {}

    SwagDev::Project::Tools.new(@tools)
  end

  def tools=(tools)
    SwagDev::Project::Tools.items = tools.to_h
  end
end
