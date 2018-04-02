# frozen_string_literal: true

require_relative '../dsl'

# rubocop:disable Style/Documentation
module SwagDev::Project::DSL
  module Definition
  end
end
# rubocop:enable Style/Documentation

# ``DSL::Definition`` provides access to ``project`` and ``tools`` methods
module SwagDev::Project::DSL::Definition
  protected

  # Get project
  #
  # @return [SwagDev::Project]
  def project
    project_dsl_storage[:project] ||= SwagDev.project
  end

  # Get tools
  #
  # @return [SwagDev::Project::Tools]
  def tools
    project_dsl_storage[:tools] ||= project.tools
  end

  private

  def project_dsl_storage
    @project_dsl_storage ||= {}
  end

  def project_dsl_storage_reset
    @project_dsl_storage = {}
  end
end
