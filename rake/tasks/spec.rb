# frozen_string_literal: true

if project.path('spec').directory?
  task :spec do |_, args|
    Rake::Task[:test].invoke(*args.to_a)
  end
end
