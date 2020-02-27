# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require 'rake/clean'

# rubocop:disable Lint/UselessAssignment

# Display start time
#
# @todo add observer on watcher
# @return [Boolean]
time = proc do
  stime = Time.now.to_s.split(/\s+/)[0..1].reverse.join(' ')

  tools.fetch(:console).stdout.puts("{{green:#{stime}}}")
end

# rubocop:enable Lint/UselessAssignment

# clobber -----------------------------------------------------------
tools.fetch(:yardoc).tap do |yardoc|
  CLOBBER.include(yardoc.output_dir)
end

# watch --------------------------------------------------------------
desc 'Watch documentation changes'
task :'doc:watch' do |task|
  # ENV['LISTEN_GEM_DEBUGGING'] = '2'
  tools.fetch(:process_locker).lock!(:doc_watch) do
    begin
      tools.fetch(:yardoc_watcher).watch(true)
    rescue SystemExit, Interrupt
      exit(Errno::ECANCELED::Errno)
    end
  end
end
