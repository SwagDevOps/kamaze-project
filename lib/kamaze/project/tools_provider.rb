# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../project'

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
  # @formatter:off
  {
    Resolver: 'resolver',
  }.each { |s, fp| autoload(s, "#{__dir__}/tools_provider/#{fp}") }
  # @formatter:on

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
      "#{__dir__}/resources/config/tools.yml"
        .yield_self { |file| YAML.load_file(file) }
        .yield_self do |defaults|
        defaults.transform_keys(&:to_sym)
      end
    end
  end

  # @param [Hash] items
  def initialize(items = {})
    @items = Hash[self.class.defaults].merge(items)
    @resolver = Resolver.new
  end

  # @param [Hash] items
  # @return [self]
  def merge!(items)
    self.tap do
      items.transform_keys(&:to_sym).tap { |h| @items.merge!(h) }
    end
  end

  # Associates the value given by value with the given key.
  #
  # @param [String|Symbol] name
  # @param [Class] value
  def []=(name, value)
    value.tap do
      { name => value }.tap { |h| merge!(h) }
    end
  end

  # Prevents further modifications.
  #
  # See also ``Object#frozen?``.
  #
  # @return [self]
  def freeze
    super.tap do
      @items.freeze
    end
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

    self.items.fetch(name).yield_self do |klass|
      resolver.classify(klass).new
    end
  end

  alias get fetch

  # Get all instances at once
  #
  # @return [Hash]
  def to_h
    self.items
        .map { |k, v| [k, resolver.classify(v)] }
        .yield_self { |results| Hash[results] }
        .yield_self { |items| items.transform_values(&:new) }
  end

  # Returns ``true`` if the given key is present
  #
  # @param [Symbol|String] name
  # @return [Boolean]
  def member?(name)
    self.items.member?(name.to_sym)
  end

  protected

  # @return [Resolver]
  attr_reader :resolver

  # Base items, before (if needed) resolution.
  #
  # @return [Hash]
  attr_reader :items
end
