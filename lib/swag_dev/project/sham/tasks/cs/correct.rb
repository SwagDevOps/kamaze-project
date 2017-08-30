# frozen_string_literal: true

require 'swag_dev/project/sham'
require 'swag_dev/project/sham/tasks/cs'

SwagDev::Project::Sham.define('tasks/cs/correct') do |c|
  parent = SwagDev.project.sham!('tasks/cs/control')

  c.attributes do
    {
      description:   'Run static code analyzer, auto-correcting offenses',
      options:       parent.options + ['--auto-correct'],
      fail_on_error: parent.fail_on_error,
      prerequisites: parent.prerequisites,
    }
  end
end
