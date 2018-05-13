# frozen_string_literal: true

require_relative '../concern'
require_relative '../helper'

# Provides access to helpers
module Kamaze::Project::Concern::Helper
  protected

  # @return [Sys::Proc::Helper]
  def helper
    Kamaze::Project::Helper.instance
  end
end
