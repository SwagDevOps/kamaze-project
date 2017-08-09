# frozen_string_literal: true

require 'swag_dev/project'
require 'swag_dev/project/tasks/doc'
require 'pathname'
require 'listen'

project = SwagDev.project

# @todo use a kind of config
ignored_patterns = [
  %r{/\.#},
  /_flymake\.rb$/,
]

if (yardopts_file = Pathname.new(Dir.pwd).join('.yardopts')).file?
  namespace :doc do
    desc 'Watch documentation changes'
    task watch: ['gem:gemspec'] do
      options = {
        only:   /\.rb$/,
        ignore: ignored_patterns,
      }

      # ENV['LISTEN_GEM_DEBUGGING'] = '2'
      # rubocop:disable Lint/HandleExceptions
      begin
        paths = project.gem.spec.require_paths
        ptask = proc do
          env = { 'RAKE_DOC_WATCH' => '1' }

          sh(env, 'rake', 'doc', verbose: false)
        end

        if ptask.call
          listener = Listen.to(*paths, options) { ptask.call }
          listener.start

          sleep
        end
      rescue SystemExit, Interrupt
      end
      # rubocop:enable Lint/HandleExceptions
    end
  end
end
