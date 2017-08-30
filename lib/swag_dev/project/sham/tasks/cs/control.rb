# frozen_string_literal: true

require 'swag_dev/project/sham'
require 'swag_dev/project/sham/tasks/cs'

SwagDev::Project::Sham.define('tasks/cs/control') do |c|
  parent = SwagDev.project.sham!('tasks/cs')

  c.attributes do
    {
      description:   'Run static code analyzer',
      options:       ['--fail-level', 'E'],
      fail_on_error: true,
      prerequisites: parent.prerequisites,
    }
  end
end
