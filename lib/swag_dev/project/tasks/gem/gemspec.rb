# frozen_string_literal: true

require 'swag_dev/project/dsl'
require 'swag_dev/project/tasks/gem'

writer = project.tools.fetch(:gemspec_writer)

desc 'Update gemspec'
task 'gem:gemspec': [writer.to_s]

file writer.to_s => sham!.files do
  writer.write
end
