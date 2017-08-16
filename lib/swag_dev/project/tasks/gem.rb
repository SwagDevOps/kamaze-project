# frozen_string_literal: true

[:gemspec, :package, :install].each do |req|
  require "swag_dev/project/tasks/gem/#{req}"
end

desc 'Build all the packages'
task gem: ['gem:gemspec', 'gem:package']
