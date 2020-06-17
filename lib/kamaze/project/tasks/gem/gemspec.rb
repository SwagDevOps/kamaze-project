# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

lambda do |method, *args, **kwargs|
  tools.fetch(:gemspec_writer).yield_self do |writer|
    RUBY_VERSION >= '2.7' ? writer.public_send(method, *args, **kwargs) : writer.public_send(method, *args)
  end
end.tap do |writer|
  task "#{writer.call(:to_s)}": [:'gem:gemspec'] do |task| # rubocop:disable Style/SymbolProc
    task.reenable
  end

  desc 'Update gemspec'
  task 'gem:gemspec' do |task|
    task.reenable.tap do
      writer.call(:write, preserve_mtime: true)
    end
  end
end
