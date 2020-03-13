# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../gemspec'

# Concern for ``Gemspec``
module Kamaze::Project::Tools::Gemspec::Concern
  # @formatter:off
  {
    Reading: 'reading',
  }.each { |k, v| autoload(k, "#{__dir__}/concern/#{v}") }
  # @formatter:on
end
