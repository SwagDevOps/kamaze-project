# frozen_string_literal: true

require 'rake'
require 'swag_dev/project'

SwagDev.project do |c|
  c.subject = SwagDev::Project
  c.name = 'swag_dev-project'
  c.tasks = [
    :cs, :'cs:pre-commit',
    :doc, :'doc:watch',
    :gem, :'gem:install', :'gem:compile',
    :'misc:gitignore',
    :shell,
    :'sources:license',
    :test,
    :vagrant,
    :'version:edit',
  ].shuffle
end.load!

task default: [:gem]

task spec: [:test] if project.path('spec').directory?
