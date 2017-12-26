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
  tools   = SwagDev.project.tools
  # ENV['LISTEN_GEM_DEBUGGING'] = '2'
  watcher = tools.fetch(:yardoc_watcher)

  tools.fetch(:process_locker).lock!(:doc_watch) do
    # rubocop:disable Lint/HandleExceptions
    begin
      watcher.watch(true)
    rescue SystemExit, Interrupt
    end
    # rubocop:enable Lint/HandleExceptions
  end
end
