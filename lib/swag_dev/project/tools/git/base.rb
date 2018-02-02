# frozen_string_literal: true

require_relative '../git'
require 'cliver'

# Provide base class for tool based on git
#
# @abstract
class SwagDev::Project::Tools::Git::Base
  # @param [Symbol|String] executable
  def initialize(executable = :git)
    @executable = Cliver.detect(executable)

    setup
  end

  protected

  # Path to executable (binary}
  #
  # @return [String]
  def executable
    @executable.to_s.clone.freeze
  end

  # Prepare command
  #
  # Almost used for inheritance
  def setup
    nil
  end
end
