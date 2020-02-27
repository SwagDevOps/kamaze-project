# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../concern'

# Provide access to ``mode`` (baed on environment ``PROJECT_MODE``)
module Kamaze::Project::Concern::Mode
  # Get project mode
  #
  # @return [String]
  def mode
    (ENV['PROJECT_MODE'] || 'production').freeze
  end
end
