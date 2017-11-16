# frozen_string_literal: true

require 'swag_dev/project'
[:gemspec, :package, :install]
  .each { |req| require_relative "gem/#{req}" }

desc 'Build all the packages'
task gem: ['gem:gemspec', 'gem:package']
