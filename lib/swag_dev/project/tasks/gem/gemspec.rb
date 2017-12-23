# frozen_string_literal: true

require_relative '../gem'

tools  = SwagDev.project.tools
reader = tools.fetch(:gemspec_reader)
writer = tools.fetch(:gemspec_writer)
# dependency files
files  = [writer.templated]
                .concat((reader.read&.files).to_a)
                .concat(Dir.glob(['gems.rb', 'gems.locked']))
                .map(&:to_s)
                .sort

desc 'Update gemspec'
task 'gem:gemspec': [writer.to_s]
file writer.to_s => files do
  writer.write
end
