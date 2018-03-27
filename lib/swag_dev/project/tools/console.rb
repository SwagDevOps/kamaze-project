# frozen_string_literal: true

require_relative '../tools'
require_relative 'base_tool'

# rubocop:disable Style/Documentation

class SwagDev::Project::Tools
  class Console < BaseTool
  end

  require_relative 'console/output'
end

# rubocop:enable Style/Documentation

# Provide access to a [console](https://en.wikipedia.org/wiki/System_console)
# having two outputs: ``stdout`` and ``stderr``
#
# @see SwagDev::Project::Tools::Console::Output
class SwagDev::Project::Tools::Console
  attr_writer :stdout
  attr_writer :stderr

  def setup
    @stdout ||= STDOUT
    @stderr ||= STDERR
  end

  # @return [Output]
  def stdout
    Output.new(@stdout)
  end

  # @return [Output]
  def stderr
    Output.new(@stderr)
  end

  def mutable_attributes
    [:stdout, :stderr]
  end
end
