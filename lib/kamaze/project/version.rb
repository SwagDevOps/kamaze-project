# frozen_string_literal: true

require_relative '../project'

require 'yaml'
require 'pathname'
require 'dry/inflector'

# Define version using a YAML file.
#
# @see https://github.com/jcangas/version_info
class Kamaze::Project::Version
  # Get filepath used to parse version (YAML file).
  #
  # @return [Pathname|String]
  attr_reader :file_name

  # @param [String] file_name
  def initialize(file_name = self.class.file_name)
    @file_name = file_name

    self.load_file
        .map { |k, v| self.attr_set(k, v) }
        .yield_self { |loaded| @loaded = loaded.to_h }
  end

  # @return [String]
  def to_s
    [major, minor, patch].join('.')
  end

  # @return [Hash]
  def to_h
    loaded.clone.freeze
  end

  class << self
    # Get default filename.
    #
    # @return [Pathname]
    def file_name
      Pathname.new(__dir__).join('version.yml')
    end
  end

  protected

  attr_reader :loaded

  # @return [Hash]
  def load_file
    YAML.load_file(file_name)
  end

  # @return [Dry::Inflector]
  def inflector
    Dry::Inflector.new
  end

  # Define attribute (as ro attr) and set value.
  #
  # @param [String|Symbol] attr_name
  # @param [Object] attr_value
  # @return [Array]
  def attr_set(attr_name, attr_value)
    inflector = self.inflector
    attr_name = inflector.underscore(attr_name.to_s)

    self.singleton_class.class_eval do
      attr_accessor attr_name

      protected "#{attr_name}="
    end

    self.__send__("#{attr_name}=", attr_value.freeze)

    [attr_name, attr_value.freeze].freeze
  end
end
