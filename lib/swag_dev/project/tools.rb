# coding: utf-8
# frozen_string_literal: true

require 'swag_dev/project'
require 'swag_dev/project/concern/helper'
require 'yaml'

# Tools provider
#
# Classes called tools can use ``sham`` to be instantiated.
# Shams are used (in a block initialize method) to set attributes.
# Tools are instantiated on demand,
# each demand generates a fresh new tool instance, avoiding
# the risk to reuse a previous altered version of a tool.
#
# Sample of use:
#
# ```ruby
# project.tools.get(:licenser).process do |licenser|
#   process.license     = project.version_info.fetch(:license_header)
#   process.patterns    = ['bin/*', 'lib/**/**.rb']
#   process.output      = STDOUT
# end
# ```
class SwagDev::Project::Tools
  include SwagDev::Project::Concern::Helper

  class << self
    # @type [Hash]
    # @return [Hash<Symbol, Class>]
    attr_accessor :items

    # Default tools
    #
    # Tools default values can be ``Class`` or ``String`` (or ``Symbol``),
    # when value is not a ``Class``, it is resolved using ``inflector``
    #
    # @todo permit ``SwagDev::Project`` to set its own tools
    #
    # @return [Hash]
    # @see SwagDev.Project.Helper.Inflector
    def defaults
      config = "#{__dir__}/resources/config/tools.yml"
      defaults = YAML.load_file(config)

      Hash[defaults.collect { |k, v| [k.to_sym, v] }]
    end
  end

  @items = {}

  # @param [Hash] items
  def initialize(items = {})
    @items = self.class.defaults.clone.merge(self.class.items).merge(items)
    @cache = {}
    # @type [SwagDev::Project::Helper::Inflector]
    @inflector = helper.get(:inflector)
  end

  # Get an instance from given name
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

  # Get an instance from given name
  #
  # @param [Symbol] name
  # @return [Object]
  def [](name)
    return nil unless member?(name)

    (@cache[name] ||= proc do
      klass = @items[name.to_sym]

      make(klass) if klass
    end.call)&.clone
  end

  alias get fetch

  # Get all instances at once
  #
  # @return [Hash]
  def to_h
    results = @items.map do |name, klass|
      [name, make(@cache[name] ||= klass)]
    end

    Hash[results]
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
  # @return [Object]
  def make(klass)
    (klass.is_a?(Class) ? klass : inflector.resolve(klass)).new
  end
end
