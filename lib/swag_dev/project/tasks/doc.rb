# coding: utf-8
# frozen_string_literal: true
#
# @see https://gist.github.com/chetan/1827484

require 'swag_dev/project/dsl'
require 'swag_dev/project/tasks/gem' if sham!.prerequisites.grep(/^gem(:|$)/)
require 'pathname'
require 'rake/clean'

# clobber -----------------------------------------------------------

CLOBBER.include(sham!.yardoc.output_dir)

# functions ---------------------------------------------------------

utf8fix = lambda do |output_dir|
  return unless output_dir

  threads = []
  Dir.glob("#{output_dir}/**/*.html").each do |f|
    threads << Thread.new do
      f = Pathname.new(f)
      s = f.read
           .gsub(/^\s*<meta charset="[A-Z]+-{0,1}[A-Z]+">/,
                 '<meta charset="UTF-8">')
      f.write(s)
    end
  end

  threads.map(&:join)
end

doctask = proc do
  require 'securerandom'
  require 'yard'

  # internal task name
  tname = 'doc:t_%s' % SecureRandom.hex(8)

  YARD::Rake::YardocTask.new(tname) do |t|
    t.options = proc do
      options = sham!.yardopts.options

      {
        true  => proc { options },
        false => proc do
          options + [
            '--title',
            '%s v%s' % [project.name, project.version_info[:version]]
          ]
        end
      }.fetch(options.include?('--title')).call
    end.call

    sham!.ignored_patterns.each do |pattern|
      t.options += ['--exclude', pattern]
    end
  end

  Rake::Task[tname]
end

# tasks -------------------------------------------------------------

desc 'Generate documentation (using YARD)'
task doc: sham!.prerequisites do
  doctask.call.execute
  utf8fix.call(sham!.yardoc.output_dir)
end
