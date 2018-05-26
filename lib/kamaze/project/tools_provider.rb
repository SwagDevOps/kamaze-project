# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../project'

class Kamaze::Project
  class ToolsProvider
    class Resolver
    end
  end
end

require_relative 'tools_provider/resolver'

# Tools provider
#
# Tools are instantiated on demand,
# each demand generates a fresh new tool instance, avoiding risk
# to reuse a previous altered version of a tool.
#
# Sample of use:
#
# ```ruby
# project.tools.fetch(:licenser).process do |licenser|
#   process.license  = project.version.license_header
#   process.patterns = ['bin/*', 'lib/**/**.rb']
#   process.output   = STDOUT
# end
# ```
class Kamaze::Project::ToolsProvider
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
    @resolver = Resolver.new
  end

  # @param [Hash] items
  # @return [self]
  def merge!(items)
    items = Hash[items.map { |k, v| [k.to_sym, v] }]
    @cache.delete_if { |k| items.member?(k) }

    @items.merge!(items)

    self
  end

  # Associates the value given by value with the given key.
  #
  # @param [String|Symbol] name
  # @param [Class] value
  def []=(name, value)
    merge!(name => value)
  end

  # Prevents further modifications.
  #
  # See also ``Object#frozen?``.
  #
  # @return [self]
  def freeze
    @items.freeze
    super
  end

  # Get a fresh instance with given name
  #
  # @param [Symbol|String] name
  # @return [Object]
  # @raise [KeyError]
  def fetch(name)
    raise KeyError, "key not found: :#{name}" unless member?(name)

    self[name]
  end

  # Get a fresh instance with given name
  #
  # @param [Symbol|String] name
  # @return [Object|nil]
  def [](name)
    name = name.to_sym

    return nil unless member?(name)

    @cache[name] ||= @items.fetch(name).yield_self do |klass|
      resolver.classify(klass)
    end

    @cache.fetch(name).new
  end

  alias get fetch

  # Get all instances at once
  #
  # @return [Hash]
  def to_h
    @items
      .map { |k, v| [k, @cache[k] ||= resolver.classify(v)] }
      .yield_self { |results| Hash[results] }
      .yield_self { |items| Hash[items.collect { |k, v| [k, v.new] }] }
  end

  # Returns ``true`` if the given key is present
  #
  # @param [Symbol|String] name
  # @return [Boolean]
  def member?(name)
    name = name.to_sym

    @items.member?(name)
  end

  protected

  # @return [Resolver]
  attr_reader :resolver

  # Base items, before (if needed) resolution.
  #
  # @return [Hash]
  attr_reader :items

  # Used to avoid classes resolution.
  #
  # @return [Hash]
  attr_reader :cache
end
