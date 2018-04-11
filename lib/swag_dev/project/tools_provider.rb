# frozen_string_literal: true

require_relative '../project'
require_relative '../project/concern/helper'

class SwagDev::Project
  class ToolsProvider
  end
end

# Tools provider
#
# Tools are instantiated on demand,
# each demand generates a fresh new tool instance, avoiding
# the risk to reuse a previous altered version of a tool.
#
# Sample of use:
#
# ```ruby
# project.tools.fetch(:licenser).process do |licenser|
#   process.license  = project.version_info.fetch(:license_header)
#   process.patterns = ['bin/*', 'lib/**/**.rb']
#   process.output   = STDOUT
# end
# ```
class SwagDev::Project::ToolsProvider
  include SwagDev::Project::Concern::Helper

  class << self
    # Default tools
    #
    # Tools default values can be ``Class`` or ``String`` (or ``Symbol``),
    # when value is not a ``Class``, it is resolved using ``inflector``
    #
    # @return [Hash]
    def defaults
      items.freeze
    end

    protected

    # Get items
    #
    # Items are collected from a YAML file.
    #
    # @return [Hash]
    def items
      config = "#{__dir__}/resources/config/tools.yml"
      defaults = YAML.load_file(config)

      Hash[defaults.collect { |k, v| [k.to_sym, v] }]
    end
  end

  # @param [Hash] items
  def initialize(items = {})
    @items = Hash[self.class.defaults].merge(items)
    @cache = {}
    # @type [SwagDev::Project::Helper::Inflector]
    @inflector = helper.get(:inflector)
  end

  # @param [Hash] items
  # @return [self]
  def merge!(items)
    items.each_key { |k| @cache.delete(k.to_sym) }
    @items.merge(items)

    self
  end

  # Get a fresh instance with given name
  #
  # @param [Symbol] name
  # @return [Object]
  # @raise [KeyError]
  def fetch(name)
    unless member?(name)
      raise KeyError, "key not found: :#{name}"
    end

    self[name]
  end

  # Get a fresh instance with given name
  #
  # @param [Symbol] name
  # @return [Object|nil]
  def [](name)
    return nil unless member?(name)

    @cache[name] ||= proc do
      @items[name.to_sym]
        .yield_self { |klass| classify(klass) if klass }
    end.call

    @cache[name]&.new
  end

  alias get fetch

  # Get all instances at once
  #
  # @return [Hash]
  def to_h
    @items
      .map { |k, v| [k, @cache[k] ||= classify(v)] }
      .yield_self { |results| Hash[results] }
      .yield_self { |items| Hash[items.collect { |k, v| [k, v.new] }] }
  end

  # Returns ``true`` if the given key is present
  #
  # @return [Boolean]
  def member?(key)
    @items.member?(key.to_sym)
  end

  protected

  # @return [SwagDev::Project::Helper::Inflector]
  attr_reader :inflector

  # Instantiate a ``Class`` (as ``klass``)
  #
  # @param [String|Symbol|Class] klass
  # @return [Class]
  def classify(klass)
    klass.is_a?(Class) ? klass : inflector.resolve(klass)
  end
end
