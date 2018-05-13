# frozen_string_literal: true

require 'rake'
require 'kamaze/project'

Kamaze.project do |c|
  c.subject = Kamaze::Project
  c.name = 'kamaze-project'
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
