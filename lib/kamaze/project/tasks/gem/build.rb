# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require 'rake/clean'
autoload(:YAML, 'yaml')

builder = lambda do |method, *args|
  tools.fetch(:gemspec_builder).public_send(*[method].push(*args))
end

writer = lambda do |method, *args|
  tools.fetch(:gemspec_writer).public_send(*[method].push(*args))
end

# Generate gemspec file (when missing) -------------------------------
# writer.call(:write) unless builder.call(:buildable?)

# clobber ------------------------------------------------------------
CLOBBER.include(builder.call(:package_dir))

# task ---------------------------------------------------------------
task builder.call(:buildable) => [writer.call(:to_s)] do |task|
  task.reenable.tap do
    # @formatter: off
    builder.call(:source_files).to_a
           .concat([Pathname.new(writer.call(:to_s))])
           .map { |file| File.mtime(file) }.max.tap do |mtime|
      lambda do # @formatter: on
        builder.call(:buildable).tap do |build|
          return build.file? ? File.mtime(build) : nil
        end
      end.call.tap do |build_mtime|
        if build_mtime.nil? || (build_mtime && mtime > build_mtime)
          builder.call(:build)
          Rake::Task['clobber'].reenable
        end
      end
    end
  end
end

# task ---------------------------------------------------------------
task :'gem:build', [writer.call(:to_s)] do |task|
  task.reenable.tap do
    [writer.call(:to_s), builder.call(:buildable)].each do |t|
      Rake::Task[t].invoke
    end
  end
end
