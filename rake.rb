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

if project.path('spec').directory?
  task :spec do |task, args|
    Rake::Task[:test].invoke(*args.to_a)
  end
end
