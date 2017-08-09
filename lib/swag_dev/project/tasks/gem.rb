# frozen_string_literal: true

require 'swag_dev/project'
require 'swag_dev/project/tasks/gem/gemspec'
require 'swag_dev/project/tasks/gem/package'
require 'rake/clean'
require 'cliver'

project = SwagDev.project

desc 'Build all the packages'
task gem: ['gem:gemspec', 'gem:package']

namespace :gem do
  desc 'Update gemspec'
  task gemspec: "#{project.name}.gemspec"

  desc 'Install gem'
  task install: ['gem:package'] do
    require 'cliver'

    sh(*[Cliver.detect(:sudo),
         Cliver.detect!(:gem),
         :install,
         project.spec.gem].compact.map(&:to_s))
  end

  # @see http://guides.rubygems.org/publishing/
  # @see rubygems-tasks
  #
  # Code mostly base on gem executable
  desc 'Push gem up to the gem server'
  task push: ['gem:package'] do
    ['rubygems',
     'rubygems/gem_runner',
     'rubygems/exceptions'].each { |i| require i }

    args = ['push', project.spec.gem]
    begin
      Gem::GemRunner.new.run(args.map(&:to_s))
    rescue Gem::SystemExitException => e
      exit e.exit_code
    end
  end
end
