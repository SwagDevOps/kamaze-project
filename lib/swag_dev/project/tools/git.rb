# frozen_string_literal: true

require_relative '../tools'
require 'open3'
require 'cliver'

# rubocop:disable Style/Documentation
class SwagDev::Project::Tools
  class Git
    class Command
      protected

      def executable
        SwagDev::Project::Tools::Git.executable
      end

      def command
        [executable]
      end
    end

    class Status < Command
      class Buffer
      end

      require_relative 'git/status'
    end

    class << self
      # @raise Cliver::Dependency::NotFound
      def executable
        Cliver.detect(:git)
      end
    end
  end
end
# rubocop:enable Style/Documentation
