# frozen_string_literal: true

require_relative '../project'
require_relative '../../config'

# Config used to configure ``SwagDev::Project``
#
# @see SwagDev::Project.initialize
class SwagDev::Project::Helper::Project::Config < SwagDev::Project::Config
  # @return [Hash]
  def defaults
    {
      tasks: nil,
      name: nil,
      subject: nil,
      tools: {}
    }
  end
end
