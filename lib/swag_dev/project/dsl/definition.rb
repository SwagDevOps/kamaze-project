# frozen_string_literal: true

require 'swag_dev/project'
require 'swag_dev/project/dsl'

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
end
