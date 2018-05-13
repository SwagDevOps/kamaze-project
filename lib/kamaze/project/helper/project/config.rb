# frozen_string_literal: true

require_relative '../project'
require_relative '../../config'

# Config used to configure ``Kamaze::Project``
#
# @see Kamaze::Project.initialize
class Kamaze::Project::Helper::Project::Config < Kamaze::Project::Config
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
