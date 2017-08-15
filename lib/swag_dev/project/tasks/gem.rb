# frozen_string_literal: true

require 'swag_dev/project'
[:gemspec, :package, :install, :push].each do |req|
  require "swag_dev/project/tasks/gem/#{req}"
end

project = SwagDev.project

desc 'Build all the packages'
task gem: ['gem:gemspec', 'gem:package']

namespace :gem do
  desc 'Update gemspec'
  task gemspec: "#{project.name}.gemspec"
end
