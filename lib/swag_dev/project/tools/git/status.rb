# frozen_string_literal: true

require_relative 'command'

# Provide status
#
# Capture a buffer (from a command) and provide a parsed result
class SwagDev::Project::Tools::Git::Status
  # @return [self]
  def parse!
    @parsed = buffer.parse

    self
  end

  # @return [Hash]
  def to_h
    parsed
  end

  # @param [Symbol] key
  # @return [nil|Array<File>]
  def [](key)
    to_h[key]
  end

  protected

  attr_reader :buffer

  # Prepare buffer string
  def setup
    @buffer = Buffer.new(capture_buffer).freeze
    @parsed = nil
  end

  # @return [Hash{Symbol => Array<File>}
  def parsed
    @parsed ||= proc do
      parse!
      @parsed
    end.call.freeze

    @parsed
  end

  # Get command (used to capture buffer)
  #
  # @return [Array<String>]
  def command
    super.push('status', '-z', '--untracked-files=all')
  end

  # Capture buffer
  #
  # @return [String]
  def capture_buffer
    capture[0].to_s.lines.map(&:chomp).join("\n")
  end
end
