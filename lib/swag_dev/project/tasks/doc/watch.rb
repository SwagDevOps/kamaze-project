# frozen_string_literal: true

require_relative '../doc'

tools = SwagDev.project.tools

# Display start time
#
# @todo add observer on watcher
# @return [Boolean]
time = proc do
  stime = Time.now.to_s.split(/\s+/)[0..1].reverse.join(' ')

  tools.fetch(:console).stdout.puts("{{green:#{stime}}}")
end

# watch --------------------------------------------------------------

desc 'Watch documentation changes'
task :'doc:watch' do
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
