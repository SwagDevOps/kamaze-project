# frozen_string_literal: true

require_relative '../rubocop'

# Config used during prepare method
#
# Config is defined by ``options`` and ``patterns``
class SwagDev::Project::Tools::Rubocop::Config
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
    filepaths = match_patterns(patterns)

    self.options.to_a.clone.concat(['--'] + filepaths)
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
