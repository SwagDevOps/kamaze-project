# frozen_string_literal: true

require 'pathname'

::Pathname.new('.gitignore').tap do |file|
  if file.exist?
    # desc "Reformat #{file} file"
    task file.to_s do
      file.read.lines
          .sort_by(&:downcase)
          .map(&:rstrip)
          .reject(&:empty?)
          .reject { |m| m[0] == '#' }
          .join("\n")
          .tap { |content| file.write(content) }
    end
  end
end
