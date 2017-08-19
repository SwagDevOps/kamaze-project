# coding: utf-8
# frozen_string_literal: true
#
# @see https://gist.github.com/chetan/1827484

require 'swag_dev/project/dsl'
require 'rake/clean'
sham!('tasks/doc').dependencies.values.uniq.each do |req|
  require req
end

# clobber -----------------------------------------------------------

if (output_dir = sham!('yardoc').output_dir)
  CLOBBER.include(output_dir)
end

# Tasks -------------------------------------------------------------

desc 'Generate documentation (using YARD)'
task doc: sham!('tasks/doc').dependencies.keys do
  [:pathname, :yard, :securerandom].each { |req| require req.to_s }

  # internal task name
  tname = 'doc:t_%s' % SecureRandom.hex(8)

  YARD::Rake::YardocTask.new(tname) do |t|
    t.options = proc do
      sham!('tasks/doc').yardopts.options + [
        '--title',
        '%s v%s' % [project.name, project.version_info[:version]]
      ]
    end.call + {
      false => ['--no-stats'],
      true  => [],
    }[ENV['RAKE_DOC_WATCH'].to_i.zero?]

    sham!('tasks/doc').ignored_patterns.each do |pattern|
      t.options += ['--exclude', pattern]
    end

    t.after = proc { Rake::Task['doc:after'].invoke }
  end

  Rake::Task[tname].invoke
end

namespace :doc do
  task :after do
    lambda do |output_dir|
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
    end.call(sham!('yardoc').output_dir)
  end
end
