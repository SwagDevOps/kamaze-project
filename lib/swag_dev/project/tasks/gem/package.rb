# frozen_string_literal: true

require 'rake/clean'
require_relative '../gem'

project = SwagDev.project
builder = project.tools.fetch(:gemspec_builder)

# CLOBBER.include('pkg')

task 'gem:package': (builder.source_files + [builder.buildable]).to_a do
  builder.build

  Rake::Task['clobber'].reenable
end
