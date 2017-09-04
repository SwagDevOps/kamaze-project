# frozen_string_literal: true

require 'swag_dev/project/dsl'

# More convenient than ``bundle exec``
#
# https://www.relishapp.com/rspec/rspec-core/docs/command-line/rake-task
# https://github.com/rspec/rspec-core/blob/master/lib/rspec/core/runner.rb

desc 'Run test suites'
task :test, [:tag] do |task, args|
  proc do
    require 'rspec/core'
    spec_runner = RSpec::Core::Runner
    options = sham!.rspec.options

    options += ['--tag', args[:tag]] if args[:tag]
    status = spec_runner.run(options, STDERR, STDOUT).to_i

    exit(status) unless status.zero?
  end.call
end

task spec: [:test] if project.working_dir.join('spec').directory?
