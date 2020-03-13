# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# Autoload class
class Kamaze::Project::Autoload < ::Hash
  def initialize # rubocop:disable Metrics/MethodLength
    # @formatter:off
    {
      VERSION: 'version',
      Bundled: 'bundled',
      Concern: 'concern',
      Config: 'config',
      Debug: 'debug',
      DSL: 'dsl',
      Helper: 'helper',
      Observable: 'observable',
      Observer: 'observer',
      Struct: 'struct',
      Tools: 'tools',
      ToolsProvider: 'tools_provider',
    }.each { |k, v| self[k] = v }
    # @formatter:on
  end

  def call(path)
    self.tap do
      self.each do |s, fp|
        Kamaze::Project.__send__(:autoload, s, "#{path}/#{fp}")
      end
    end
  end
end
