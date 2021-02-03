# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../project'

# namespace for dsl concerns
module Kamaze::Project::DSL
  # @formatter:off
  {
    Definition: 'definition'
  }.each do |s, fp|
    autoload(s, "#{__dir__}/dsl/#{fp}")
  end
  # @formatter:on
end
