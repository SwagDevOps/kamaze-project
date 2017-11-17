# frozen_string_literal: true

require 'rake/clean'
require_relative '../gem'

project = SwagDev.project
builder = project.tools.fetch(:gemspec_builder)

CLOBBER.include(builder.package_dir)

file builder.buildable => builder.source_files.to_a.map(&:to_s) do
  builder.build

  Rake::Task['clobber'].reenable
end

task 'gem:build': [builder.buildable]
