# frozen_string_literal: true

require 'swag_dev/project/dsl'
require 'swag_dev/project/tasks/doc'
require 'pathname'
require 'listen'

# Tasks -------------------------------------------------------------

namespace :doc do
  desc 'Watch documentation changes'
  task watch: project.sham!('tasks/doc').dependencies.keys do
    timer = proc do
      time = Time.now.to_s.split(/\s+/)[0..1].reverse.join(' ')

      console.writeln(STDOUT, time, :green, :bold)
    end

    ptask = proc do
      timer.call

      Rake::Task[:doc]
        .prerequisites
        .each { |pre| Rake::Task[pre].reenable }

      Rake::Task[:doc].reenable
      Rake::Task[:doc].invoke
    end

    begin
      if ptask.call
        # ENV['LISTEN_GEM_DEBUGGING'] = '2'
        paths   = project.gem.spec.require_paths
        options = project.sham!('tasks/doc/watch').listen_options

        listener = Listen.to(*paths, options) { ptask.call }
        listener.start

        sleep
      end
    rescue SystemExit, Interrupt
    end
  end
end
