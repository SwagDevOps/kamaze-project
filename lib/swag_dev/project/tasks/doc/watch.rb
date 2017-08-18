# frozen_string_literal: true

require 'swag_dev/project/dsl'
require 'swag_dev/project/tasks/doc'
require 'pathname'
require 'listen'

# Tasks -------------------------------------------------------------

namespace :doc do
  desc 'Watch documentation changes'
  task watch: project.sham!('tasks/doc').dependencies.keys do
    options = {
      only:   /\.rb$/,
      ignore: project.sham!('tasks/doc').ignored_patterns
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
