# frozen_string_literal: true

require_relative '../concern'
require_relative '../../project/tools_provider'

# Provides access to tools
#
# Tools provide an extensibility mechanism
module Kamaze::Project::Concern::Tools
  # Get tools
  #
  # @return [Hash]
  def tools
    @tools ||= Kamaze::Project::ToolsProvider.new
  end

  # @param [Hash] tools
  def tools=(tools)
    @tools = self.tools.merge!(tools)
  end
end
