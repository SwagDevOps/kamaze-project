# frozen_string_literal: true

reader = tools.fetch(:gemspec_reader)
writer = tools.fetch(:gemspec_writer)

files = [writer.templated]
        .concat((reader.read&.files).to_a)
        .concat(Dir.glob(['gems.rb', 'gems.locked'])).map(&:to_s).sort

# task 'gem:gemspec': [writer.to_s]
desc 'Update gemspec'
file writer.to_s => files do
  writer.write
end
