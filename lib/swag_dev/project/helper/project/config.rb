# frozen_string_literal: true

require 'swag_dev/project/helper/project'
require 'swag_dev/project/config'

# Config used to configure ``SwagDev::Project``
#
# @see SwagDev::Project.initialize
class SwagDev::Project::Helper::Project::Config < SwagDev::Project::Config
  # @return [Hash]
  def defaults
    {
      tasks: nil,
      working_dir: Dir.pwd,
      name: nil,
      subject: nil,
      tools: {}
    }
  end
end
