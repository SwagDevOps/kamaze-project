# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require 'rake/clean'
autoload(:YAML, 'yaml')
autoload(:Pathname, 'pathname')

builder = lambda do |method, *args|
  tools.fetch(:gemspec_builder).public_send(*[method].push(*args))
end

writer = lambda do |method, *args|
  tools.fetch(:gemspec_writer).public_send(*[method].push(*args))
end

runner = lambda do
  mtime = builder.call(:source_files)
                 .to_a
                 .concat([writer.call(:to_s)])
                 .map { |fp| Pathname.new(fp) }
                 .map(&:mtime).max || Time.now

  lambda do
    builder.call(:buildable).yield_self { |build| build.file? ? File.mtime(build) : nil }
  end.call.tap do |build_mtime|
    if build_mtime.nil? || (build_mtime and mtime > build_mtime)
      builder.call(:build)
      Rake::Task[:clobber].reenable
    end
  end
end

# clobber ------------------------------------------------------------
CLOBBER.include(builder.call(:package_dir))

# task ---------------------------------------------------------------
task(:'gem:build', [writer.call(:to_s)]) do |task|
  task.reenable.tap do
    runner.call

    [writer.call(:to_s), builder.call(:buildable)].each do |t|
      Rake::Task[t].invoke
    end
  end
end
