# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../project'
require_relative 'tools_provider'

# Namespace for tools
module Kamaze::Project::Tools
  # @formatter:off
  {
    Git: 'git',
    BaseTool: 'base_tool',
  }.each { |k, v| autoload(k, "#{__dir__}/tools/#{v}") }
  # @formatter:on
end
