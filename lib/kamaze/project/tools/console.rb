# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../tools'

# Provide access to a [console](https://en.wikipedia.org/wiki/System_console)
# having two outputs: ``stdout`` and ``stderr``
#
# @see Kamaze::Project::Tools::Console::Output
class Kamaze::Project::Tools::Console < Kamaze::Project::Tools::BaseTool
  autoload(:Output, "#{__dir__}/console/output")

  attr_writer :stdout
  attr_writer :stderr

  def setup
    @stdout ||= $stdout
    @stderr ||= $stderr
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
