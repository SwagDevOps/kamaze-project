# frozen_string_literal: true

require 'swag_dev/project'

# Require base tasks -------------------------------------------------
[:gemspec, :build, :install]
  .each { |req| require_relative "gem/#{req}" }

# Default task -------------------------------------------------------
desc 'Build all the packages'
task gem: [:'gem:build']
