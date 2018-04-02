# frozen_string_literal: true

require_relative '../../project'

# https://www.relishapp.com/rspec/rspec-core/docs/command-line/rake-task
# https://github.com/rspec/rspec-core/blob/master/lib/rspec/core/runner.rb
# https://relishapp.com/rspec/rspec-core/v/2-4/docs/command-line/tag-option
desc 'Run test suites'
task :test, [:tags] do |task, args|
  SwagDev.project.tools.fetch(:rspec).tap do |rspec|
    rspec.tags = args[:tags].to_s.split(',').map(&:strip)
  end.run
end
