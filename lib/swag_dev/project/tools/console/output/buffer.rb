# frozen_string_literal: true

require_relative '../output'
require 'cli/ui'

class SwagDev::Project::Tools::Console::Output
  class Buffer
  end
end

# Describe a buffer
class SwagDev::Project::Tools::Console::Output::Buffer
  attr_reader :content

  # @param [SwagDev::Project::Tools::Console::Output] output
  # @param [String] content
  def initialize(output, content)
    @output = output
    @content = content
  end

  def to_s
    self.decorate(content)
  end

  protected

  attr_reader :output

  # @param [String] s
  # @return [String]
  def decorate(s)
    CLI::UI.fmt(s, enable_color: output.tty?)
  end
end
