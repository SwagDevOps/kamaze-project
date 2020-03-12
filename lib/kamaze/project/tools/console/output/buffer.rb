# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../output'

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
    ui.fmt(str.to_s, enable_color: output.tty?)
  end

  def ui
    require 'cli/ui'

    CLI::UI
  end
end
