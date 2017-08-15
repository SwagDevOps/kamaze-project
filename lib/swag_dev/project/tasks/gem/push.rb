# frozen_string_literal: true
# -*- coding: utf-8 -*-

require 'swag_dev/project'
require 'swag_dev/project/tasks/gem'

namespace :gem do
  # @see http://guides.rubygems.org/publishing/
  # @see rubygems-tasks
  #
  # Code mostly base on gem executable
  desc 'Push gem up to the gem server'
  task push: ['gem:package'] do
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
end
