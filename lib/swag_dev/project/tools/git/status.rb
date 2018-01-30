# frozen_string_literal: true

require_relative 'command'

# Provide status
class SwagDev::Project::Tools::Git::Status
  def parse!
    @parsed = buffer.parse

    self
  end

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

  def parsed
    @parsed ||= proc do
      parse!
      @parsed
    end.call.freeze

    @parsed
  end

  def command
    super.push('status', '-z', '--untracked-files=all')
  end

  def capture_buffer
    capture[0].to_s.lines.map(&:chomp).join("\n")
  end
end
