# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../dsl'

# ``DSL::Definition`` provides access to ``project`` and ``tools`` methods
module Kamaze::Project::DSL::Definition
  protected

  # Get project
  #
  # @return [Kamaze::Project]
  def project
    @project_dsl_stored ||= Kamaze::Project.instance
  end

  # Get tools
  #
  # @return [Kamaze::Project::ToolsProvider]
  def tools
    project.tools
  end

  private

  # @return [self]
  def project_dsl_reset
    self.tap do
      @project_dsl_stored = nil
    end
  end
end
