# frozen_string_literal: true

require 'swag_dev/project/dsl'
require 'swag_dev/project/tasks/doc'

# Display time
#
# @return [Boolean]
time = proc do
  stime = Time.now.to_s.split(/\s+/)[0..1].reverse.join(' ')

  !!(console.stdout.writeln(stime, :green, :bold))
end

# Execute ``:doc`` task (with prerequisites)
#
# @return [Boolean]
main = proc do
  time.call

  [:reenable, :invoke].each { |m| Rake::Task[:doc].public_send(m) }

  true
end

# Setup listen
listen = proc do
  # ENV['LISTEN_GEM_DEBUGGING'] = '2'
  paths   = project.gem.spec.require_paths
  options = sham!.listen_options

  return unless main.call

  listener = Listen.to(*paths, options) { main.call }
  listener.start

  sleep
end

desc 'Watch documentation changes'
task :'doc:watch' do
  require 'listen'

  begin
    listen.call
  rescue SystemExit, Interrupt
  end
end
