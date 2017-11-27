# frozen_string_literal: true

require 'rake/clean'
require_relative '../gem'

tools   = SwagDev.project.tools
builder = tools.fetch(:gemspec_builder)

CLOBBER.include(builder.package_dir)

# Generate gemspec file (when missing) -------------------------------

tools.fetch(:gemspec_writer).write unless builder.buildable?

# Tasks --------------------------------------------------------------

file builder.buildable => builder.source_files.to_a.map(&:to_s) do
  builder.build

  Rake::Task['clobber'].reenable
end

task 'gem:build': [:'gem:gemspec', builder.buildable]
