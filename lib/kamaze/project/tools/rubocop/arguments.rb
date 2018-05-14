# frozen_string_literal: true

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