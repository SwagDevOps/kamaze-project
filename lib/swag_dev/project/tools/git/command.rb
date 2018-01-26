# frozen_string_literal: true

require_relative '../git'
require 'open3'
require 'cliver'

# Provide base command
#
# @abstract
class SwagDev::Project::Tools::Git::Command
  # @param [Symbol|String] executable
  def initialize(executable = :git)
    @executable = Cliver.detect(executable)

    setup
  end

  protected

  # Prepare command
  #
  # Almost used for inheritance
  def setup
    nil
  end

  # Path to executable (binary}
  #
  # @return [String]
  def executable
    @executable.to_s.clone.freeze
  end

  # Base command for ``git``
  #
  # @return [Array<String>]
  def command
    [executable]
  end

  def capture
    Open3.capture3(*command)
  end
end
