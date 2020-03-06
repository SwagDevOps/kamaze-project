# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

lambda do |method, *args|
  tools.fetch(:gemspec_writer).public_send(*[method].push(*args))
end.tap do |writer|
  task "#{writer.call(:to_s)}": [:'gem:gemspec'] do |task| # rubocop:disable Style/SymbolProc
    task.reenable
  end

  desc 'Update gemspec'
  task 'gem:gemspec' do |task|
    writer.call(:write, preserve_mtime: true)

    task.reenable
  end
end
