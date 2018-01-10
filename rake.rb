# frozen_string_literal: true

require 'swag_dev/project'
require 'rake'

SwagDev.project do |c|
  c.subject = SwagDev::Project
  c.name = 'swag_dev-project'
  c.tasks = [
    :'cs:correct', :'cs:control',
    :doc, :'doc:watch',
    :gem, :'gem:compile',
    :'misc:gitignore',
    :shell,
    :'sources:license',
    :test,
    :vagrant,
    :'version:edit',
  ].shuffle
end.load!

task default: [:gem]

task spec: [:test] if SwagDev.project.path('spec').directory?
