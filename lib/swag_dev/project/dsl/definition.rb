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
    @project_dsl_stored ||= SwagDev.project
  end

  # Get tools
  #
  # @return [SwagDev::Project::ToolsProvider]
  def tools
    project.tools
  end

  private

  def project_dsl_reset
    @project_dsl_stored = nil

    self
  end
end
