# frozen_string_literal: true

require_relative '../tools'
require_relative 'base_tool'
require 'cliver'

# rubocop:disable Style/Documentation
class SwagDev::Project::Tools
  class Git < BaseTool
    class Command
      class Buffer
      end
    end
    require_relative 'git/command'

    class Status < Command
    end
    require_relative 'git/status'
    # require_relative 'git/status/buffer'

    class << self
      # Path to executable (binary}
      #
      # @return [String]
      # @raise Cliver::Dependency::NotFound
      def executable
        Cliver.detect(:git)
      end
    end
  end
end
# rubocop:enable Style/Documentation

# Provide some git related features
class SwagDev::Project::Tools::Git
  # @return [String]
  attr_accessor :executable

  # Instance attributes altered during initialization
  #
  # @return [Array<Symbol>]
  def mutable_attributes
    [:executable]
  end

  # Get status
  #
  # @return [Status]
  def status
    Status.new(executable)
  end

  protected

  def setup
    @executable ||= self.class.executable
  end
end
