# frozen_string_literal: true
# -*- coding: utf-8 -*-

require 'rubygems'
require_relative '../gem'
[:gem_runner, :exceptions].each { |req| require "rubygems/#{req}" }

# Code mostly based on gem executable
#
# @see http://guides.rubygems.org/publishing/
# @see rubygems-tasks
desc 'Push gem up to the gem server'
task 'gem:push': ['gem:build'] do
  builder = SwagDev.project.tools.fetch(:gemspec_builder)
  args = [:push, builder.buildable].map(&:to_s)

  begin
    Gem::GemRunner.new.run(args.map(&:to_s))
  rescue Gem::SystemExitException => e
    exit e.exit_code
  end
end
