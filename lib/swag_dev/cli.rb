# frozen_string_literal: true

module SwagDev
  # CLi module
  module Cli
    require 'swag_dev/cli/output'

    class << self
      # Write message to given output
      #
      # @param [IO|STDOUT|STDERR] to
      # @param [String] s
      def writeln(to, s, *args)
        Output.new(to).writeln(s, *args)
      end
    end
  end
end
