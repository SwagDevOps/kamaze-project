# frozen_string_literal: true

require 'swag_dev/project/dsl'
require 'swag_dev/project/tasks/doc'

namespace :doc do
  desc 'Watch documentation changes'
  task watch: project.sham!('tasks/doc').dependencies.keys do
    # Display time
    #
    # @return [Boolean]
    timer = proc do
      time = Time.now.to_s.split(/\s+/)[0..1].reverse.join(' ')

      !!(console.stdout.writeln(time, :green, :bold))
    end

    # Execute ``:doc`` task (with prerequisites)
    #
    # @return [Boolean]
    ptask = proc do
      timer.call

      Rake::Task[:doc]
        .prerequisites
        .each { |pre| Rake::Task[pre].reenable }
      [:reenable, :invoke]
        .each { |m| Rake::Task[:doc].public_send(m) }

      true
    end

    # Setup listen
    ltask = proc do
      # ENV['LISTEN_GEM_DEBUGGING'] = '2'
      paths   = project.gem.spec.require_paths
      options = project.sham!('tasks/doc/watch').listen_options

      return unless ptask.call

      listener = Listen.to(*paths, options) { ptask.call }
      listener.start

      sleep
    end

    begin
      require 'listen'

      ltask.call
    rescue SystemExit, Interrupt
    end
  end
end
