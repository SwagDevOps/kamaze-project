# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../rubocop'

# Config used during prepare method
#
# Config is defined by ``options`` and ``patterns``
class Kamaze::Project::Tools::Rubocop::Config
  # Patterns used to match files
  #
  # @type [Array]
  # @return [Array]
  attr_accessor :patterns

  # Command options
  #
  # @type [Array]
  # @return [Array]
  attr_accessor :options

  # @return [Array<String>]
  def to_a
    self.options.to_a.clone.concat(['--']).concat(match_patterns(patterns))
  end

  protected

  # Match against given patterns
  #
  # @param [Array<String>] patterns
  # @return [Array<String>]
  def match_patterns(patterns)
    Dir.glob(patterns)
  end
end
