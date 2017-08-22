# frozen_string_literal: true

require 'swag_dev/project/dsl'
require 'swag_dev/project/tasks/doc'

project.sham!('tasks/doc')

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
prepare = proc do
  timer.call

  Rake::Task[:doc]
    .prerequisites
    .each { |pre| Rake::Task[pre].reenable }
  [:reenable, :invoke]
    .each { |m| Rake::Task[:doc].public_send(m) }

  true
end

# Setup listen
listen = proc do
  # ENV['LISTEN_GEM_DEBUGGING'] = '2'
  paths   = project.gem.spec.require_paths
  options = project.sham!('tasks/doc/watch').listen_options

  return unless prepare.call

  listener = Listen.to(*paths, options) { ptask.call }
  listener.start

  sleep
end

namespace :doc do
  desc 'Watch documentation changes'
  task(watch: [] + project.sham!('tasks/doc').dependencies.keys) do
    begin
      require 'listen'

      listen.call
    rescue SystemExit, Interrupt
    end
  end
end
