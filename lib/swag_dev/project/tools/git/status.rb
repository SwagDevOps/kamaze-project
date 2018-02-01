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

  # Get a string representation of status
  #
  # SHOULD be similar to:
  #
  # ```sh
  # git status -z | sed "s/\x0/\n/g"
  # ```
  def to_s
    files = []
    parsed.to_h.each_value { |items| files << items }

    files.flatten.map(&:status_line).uniq.join("\n")
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
