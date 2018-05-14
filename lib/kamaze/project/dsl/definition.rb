# frozen_string_literal: true

require_relative '../dsl'

# rubocop:disable Style/Documentation
module Kamaze::Project::DSL
  module Definition
  end
end
# rubocop:enable Style/Documentation

# ``DSL::Definition`` provides access to ``project`` and ``tools`` methods
module Kamaze::Project::DSL::Definition
  protected

  # Get project
  #
  # @return [Kamaze::Project]
  def project
    @project_dsl_stored ||= Kamaze.project
  end

  # Get tools
  #
  # @return [Kamaze::Project::ToolsProvider]
  def tools
    project.tools
  end

  private

  def project_dsl_reset
    @project_dsl_stored = nil

    self
  end
end