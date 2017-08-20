# frozen_string_literal: true

module SwagDev
  # Console module
  module Console
    require 'swag_dev/console/output'

    class << self
      # @return [SwagDev::Console::Output]
      def stdout
        Output.new(STDOUT)
      end

      # @return [SwagDev::Console::Output]
      def stderr
        Output.new(STDERR)
      end
    end
  end
end
