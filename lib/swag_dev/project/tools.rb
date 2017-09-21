# coding: utf-8
# frozen_string_literal: true

require 'swag_dev/project'
require 'swag_dev/project/concern/sham'
require 'swag_dev/project/concern/helper'

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
  class << self
    # Default tools
    #
    # Tools default values can be ``Class`` or ``String`` (or ``Symbol``),
    # when value is not a ``Class``, it is resolved using ``inflector``
    #
    # @todo permit ``SwagDev::Project`` to set its own tools
    #
    # @return [Hash]
    # @see SwagDev.Project.Helper.Inflector
    attr_reader :defaults
    attr_accessor :items
  end

  @defaults = {
    licenser:       :'swag_dev/project/tools/licenser',
    process_locker: :'swag_dev/project/tools/process_locker'
  }

  @items = {}

  def initialize(items = {})
    @items = self.class.defaults.clone.merge(self.class.items).merge(items)
    @cache = {}
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
    (@cache[name] ||= proc do
      klass = @items[name.to_sym]

      make(name, klass) if klass
    end.call)&.clone if member?(name)
  end

  alias get fetch

  # Get all instance at once
  #
  # @return [Hash]
  def to_h
    results = @items.map do |name, klass|
      [name, make(name, @cache[name] ||= klass)]
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

  include SwagDev::Project::Concern::Helper
  include SwagDev::Project::Concern::Sham

  SwagDev::Project::Concern::Sham.instance_methods.each { |m| protected m }

  # Instantiate a ``Class`` (as ``klass``) eventually using a named ``sham``
  #
  # @param [String|Symbol] name
  # @param [String|Symbol|Class] klass
  # @return [Object]
  def make(name, klass)
    klass = helper.get(:inflector).resolve(klass) unless klass.is_a?(Class)

    klass.new do |i|
      self.sham("tools/#{name}").to_h.each do |attr, value|
        i.public_send("#{attr}=", value)
      end
    end
  end
end
