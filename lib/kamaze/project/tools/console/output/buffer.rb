# frozen_string_literal: true

require_relative '../output'
require 'cli/ui'

class Kamaze::Project::Tools::Console::Output
  class Buffer
  end
end

# Describe a buffer
class Kamaze::Project::Tools::Console::Output::Buffer
  # Get content
  #
  # @return [String]
  attr_reader :content

  # @param [Kamaze::Project::Tools::Console::Output] output
  # @param [String] content
  def initialize(output, content)
    @output = output
    @content = content
  end

  # @return [String]
  def to_s
    self.decorate(content)
  end

  protected

  # @return [Kamaze::Project::Tools::Console::Output]
  attr_reader :output

  # Decorate given string depending ``output`` is a tty
  #
  # @param [String] str
  # @return [String]
  def decorate(str)
    CLI::UI.fmt(str.to_s, enable_color: output.tty?)
  end
end
