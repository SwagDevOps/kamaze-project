# frozen_string_literal: true

require_relative '../rubocop'

class SwagDev::Project::Tools::Arguments
  # @return [Array<String>]
  def to_a
    pp('Here I am')
    super.map(&:to_s)
  end
end
