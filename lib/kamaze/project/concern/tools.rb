# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../concern'

# Provides access to tools
#
# Tools provide an extensibility mechanism
module Kamaze::Project::Concern::Tools
  # Get tools
  #
  # @return [ToolsProvider|Hash]
  def tools
    @tools ||= Kamaze::Project::ToolsProvider.new
  end

  # @param [Hash] tools
  def tools=(tools)
    @tools = self.tools.merge!(tools)
  end
end
