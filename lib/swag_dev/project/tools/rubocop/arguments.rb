# frozen_string_literal: true

require_relative '../rubocop'

# Arguments
#
# Almost a basic ``Array``
class SwagDev::Project::Tools::Arguments
  # @return [Array<String>]
  def to_a
    super.map(&:to_s)
  end
end
