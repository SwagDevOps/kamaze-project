# frozen_string_literal: true

require 'swag_dev/project'

module SwagDev::Project::Dsl
end

# Module providing ``#project``, ``#sham``, ``#sham!``, etc.
module SwagDev::Project::Dsl::Definition
  protected

  # @return [SwagDev::Project]
  def project
    SwagDev.project
  end

  # @see [SwagDev::Project::Concern::Sham.sham]
  def sham(name, *args, &block)
    project.sham(name, *args, &block)
  end

  # @see [SwagDev::Project::Concern::Sham.sham!]
  def sham!(name = nil, *args)
    project.sham!(name, *args)
  end

  # @return [SwagDev::Cli]
  def console
    require 'swag_dev/console'

    SwagDev::Console
  end
end
