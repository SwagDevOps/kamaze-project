# frozen_string_literal: true

require_relative '../../project'

# More convenient than ``bundle exec``
#
# https://www.relishapp.com/rspec/rspec-core/docs/command-line/rake-task
# https://github.com/rspec/rspec-core/blob/master/lib/rspec/core/runner.rb
# https://relishapp.com/rspec/rspec-core/v/2-4/docs/command-line/tag-option
desc 'Run test suites'
task :test, [:tags] do |task, args|
  proc do
    require 'rspec/core'
    require 'shellwords'

    spec_runner = RSpec::Core::Runner
    conf_file = Pathname.new(Dir.pwd).join('.rspec')
    optionner = lambda do |file|
      file.file? ? Shellwords.split(file.read) : []
    end

    options = optionner.call(conf_file)
    args[:tags]
      .to_s
      .split(',')
      .map(&:strip).each { |tag| options += ['--tag', tag] }

    status = spec_runner.run(options, STDERR, STDOUT).to_i

    exit(status) unless status.zero?
  end.call
end
