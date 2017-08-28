# frozen_string_literal: true

require 'swag_dev/project'

module SwagDev::Project::Dsl
end

# Module providing ``#project``, ``#sham``, ``#sham!``, etc.
module SwagDev::Project::Dsl::Definition
  protected

  # @return [SwagDev::Project]
  def project(&block)
    SwagDev.project(&block).load!
  end

  # @see [SwagDev::Project::Concern::Sham.sham]
  def sham(name = nil, *args, &block)
    name ||= task_sham_name unless block

    project.sham(name, *args, &block)
  end

  # @see [SwagDev::Project::Concern::Sham.sham!]
  def sham!(name = nil, *args)
    name ||= task_sham_name

    project.sham!(name, *args)
  end

  # Get sham (default name) depending on caller
  #
  # @api private
  # @return [String]
  def task_sham_name
    'tasks/%s' % caller.grep(%r{/tasks/})
                       .fetch(0)
                       .split(%r{/tasks/})
                       .fetch(1).split('.rb:')
                       .fetch(0)
  end

  # @return [SwagDev::Cli]
  def console
    require 'swag_dev/console'

    SwagDev::Console
  end
end
