# frozen_string_literal: true

# Require base tasks -------------------------------------------------
[:gemspec, :build].each { |req| require_relative "gem/#{req}" }

# Default task -------------------------------------------------------
desc 'Build all the packages'
task gem: [:'gem:build']
