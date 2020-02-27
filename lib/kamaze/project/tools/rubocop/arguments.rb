# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../rubocop'

# Arguments
#
# Almost a basic ``Array``
class Kamaze::Project::Tools::Rubocop::Arguments < Array
  # @return [Array<String>]
  def to_a
    super.map(&:to_s)
  end
end
