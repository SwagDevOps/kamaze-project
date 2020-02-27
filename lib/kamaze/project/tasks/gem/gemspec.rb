# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

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
