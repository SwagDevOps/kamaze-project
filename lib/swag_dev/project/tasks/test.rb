# frozen_string_literal: true

require 'swag_dev/project'

# More convenient than ``bundle exec``
#
# https://www.relishapp.com/rspec/rspec-core/docs/command-line/rake-task
# https://github.com/rspec/rspec-core/blob/master/lib/rspec/core/runner.rb

desc 'Run test suites'
task :test, [:tag] do |task, args|
  proc do
    require 'rspec/core'
    require 'shellwords'

    spec_runner = RSpec::Core::Runner
    conf_file = Pathname.new(Dir.pwd).join('.rspec')
    optionner = lambda do |file|
      file.file? ? Shellwords.split(file.read) : []
    end

    options = optionner.call(conf_file)
    options += ['--tag', args[:tag]] if args[:tag]
    status = spec_runner.run(options, STDERR, STDOUT).to_i

    exit(status) unless status.zero?
  end.call
end

task spec: [:test] if SwagDev.project.working_dir.join('spec').directory?
