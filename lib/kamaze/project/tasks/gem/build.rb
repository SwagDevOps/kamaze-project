# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require 'rake/clean'

builder = tools.fetch(:gemspec_builder)
writer = tools.fetch(:gemspec_writer)

# Generate gemspec file (when missing) -------------------------------
writer.write unless builder.buildable?

# clobber ------------------------------------------------------------
CLOBBER.include(builder.package_dir)

# task ---------------------------------------------------------------
file builder.buildable => builder.source_files.to_a.map(&:to_s) do
  builder.build

  Rake::Task['clobber'].reenable
end

# task ---------------------------------------------------------------
task 'gem:build' do |task|
  [writer.to_s, builder.buildable].each do |t|
    Rake::Task[t].invoke
  end

  task.reenable
end
