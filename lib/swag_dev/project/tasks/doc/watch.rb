# frozen_string_literal: true

require_relative '../doc'

# Display start time
#
# @todo add observer on watcher
# @return [Boolean]
time = proc do
  stime = Time.now.to_s.split(/\s+/)[0..1].reverse.join(' ')

  SwagDev::Console.new.stdout.writeln(stime, :green, :bold) ? true : false
end

# watch --------------------------------------------------------------

desc 'Watch documentation changes'
task :'doc:watch' do
  # ENV['LISTEN_GEM_DEBUGGING'] = '2'
  watcher = SwagDev.project.tools.fetch(:yardoc_watcher)

  begin
    watcher.watch(true)
  rescue SystemExit, Interrupt
  end
end
