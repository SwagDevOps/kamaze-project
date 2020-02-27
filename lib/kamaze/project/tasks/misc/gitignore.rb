# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require 'pathname'

::Pathname.new('.gitignore').tap do |file|
  if file.exist?
    # desc "Reformat #{file} file"
    task file.to_s do
      lines = file.read.lines
                  .map(&:rstrip)
                  .reject(&:empty?)
                  .reject { |m| m[0] == '#' }
                  .sort_by(&:downcase)

      {
        regular: lines.clone.reject { |m| m[0] == '!' }.freeze,
        inverse: lines.clone.keep_if { |m| m[0] == '!' }.freeze,
      }.values.flatten.yield_self do |rules|
        rules.join("\n").tap { |content| file.write(content) }
      end
    end
  end
end
