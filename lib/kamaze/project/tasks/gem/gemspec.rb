# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# @type [Kamaze::Project::Tools::Gemspec::Writer] writer
tools.fetch(:gemspec_writer).tap do |writer|
  task writer.to_s => [:'gem:gemspec'] do |task| # rubocop:disable Style/SymbolProc
    task.reenable
  end

  desc 'Update gemspec'
  task 'gem:gemspec' do |task|
    task.reenable.tap do
      writer.write(preserve_mtime: true)
    end
  end
end
