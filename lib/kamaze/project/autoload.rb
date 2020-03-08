# frozen_string_literal: true

# Autoload class
class Kamaze::Project::Autoload < ::Hash
  def initialize # rubocop:disable Metrics/MethodLength
    # @formatter:off
    {
      VERSION: 'version',
      BootsnapConfig: 'bootsnap_config',
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
