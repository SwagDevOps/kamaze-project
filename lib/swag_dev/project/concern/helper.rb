# frozen_string_literal: true

require 'active_support/concern'

require 'swag_dev/project/concern'
require 'swag_dev/project/helper'

# Provides access to helpers
module SwagDev::Project::Concern::Helper
  extend ActiveSupport::Concern

  protected

  # @return [Sys::Proc::Helper]
  def helper
    SwagDev::Project::Helper.instance
  end
end
