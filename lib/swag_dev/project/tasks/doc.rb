# coding: utf-8
# frozen_string_literal: true
#
# @see https://gist.github.com/chetan/1827484

require 'swag_dev/project'
require 'swag_dev/project/sham/tasks/doc'
require 'rake/clean'

project = SwagDev.project
config = project.sham!('tasks/doc')
output_dir = project.yardoc.options[:serializer]&.basepath
config.dependencies.to_h.values.uniq.each { |req| require req }

# clobber -----------------------------------------------------------

CLOBBER.include(output_dir) if output_dir

# Tasks -------------------------------------------------------------

desc 'Generate documentation (using YARD)'
task doc: config.dependencies.to_h.keys do
  [:pathname, :yard, :securerandom].each { |req| require req.to_s }

  # internal task name
  tname = 'doc:t_%s' % SecureRandom.hex(8)

  YARD::Rake::YardocTask.new(tname) do |t|
    t.options = proc do
      config.yardopts.options + [
        '--title',
        '%s v%s' % [project.name, project.version_info[:version]]
      ]
    end.call + {
      false => ['--no-stats'],
      true  => [],
    }[ENV['RAKE_DOC_WATCH'].to_i.zero?]

    config.ignored_patterns.each do |regexp|
      t.options += ['--exclude', regexp.inspect.gsub(%r{^/|/$}, '')]
    end

    t.after = proc { Rake::Task['doc:after'].invoke }
  end

  Rake::Task[tname].invoke
end

namespace :doc do
  task :after do
    proc do
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
  end
end
