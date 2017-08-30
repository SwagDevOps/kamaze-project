# frozen_string_literal: true
# -*- coding: utf-8 -*-

require 'swag_dev/project/dsl'
require 'swag_dev/project/tasks/gem'

# Code mostly based on gem executable
#
# @see http://guides.rubygems.org/publishing/
# @see rubygems-tasks
desc 'Push gem up to the gem server'
task 'gem:push': ['gem:package'] do
  ['rubygems', 'rubygems/gem_runner', 'rubygems/exceptions'].each do |req|
    require req
  end

  args = ['push', project.spec.gem]
  begin
    Gem::GemRunner.new.run(args.map(&:to_s))
  rescue Gem::SystemExitException => e
    exit e.exit_code
  end
end
