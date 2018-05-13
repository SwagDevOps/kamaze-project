# frozen_string_literal: true

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
