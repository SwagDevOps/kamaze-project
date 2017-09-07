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
class SwagDev::Project::Tools
  @defaults = {
    licenser: :'swag_dev/project/tools/licenser'
  }

  class << self
    # Default tools
    #
    # Tools default values can be ``Class`` or ``String`` (or ``Symbol``),
    # when value is not a ``Class``, it is resolved using ``inflector``
    #
    # @todo permit ``SwagDev::Project`` to set its own tools
    #
    # @return [Hash]
    # @see [SwagDev::Project::Helper::Inflector]
    attr_reader :defaults
  end

  def initialize(items = {})
    @items = self.class.defaults.clone.merge(items)
    @cache = {}
  end

  # Get an instance of «tool» from given name
  #
  # @param [String] name
  # @return [Object]
  def get(name)
    name = name.to_sym

    (@cache[name] ||= proc do
      klass = @items.fetch(name.to_sym)

      make(name, klass)
    end.call).clone
  end

  # Get items (considered as tools)
  #
  # @return [Hash]
  def to_h
    @items
  end

  protected

  include SwagDev::Project::Concern::Helper
  include SwagDev::Project::Concern::Sham
  SwagDev::Project::Concern::Sham
    .instance_methods.each { |m| protected m }

  # Instantiate a ``Class`` (as ``klass``) eventually using a named ``sham``
  #
  # @param [String|Symbol] name
  # @param [String|Symbol|Class] klass
  # @return [Object]
  def make(name, klass)
    klass = helper.get(:inflector).resolve(klass) unless klass.is_a?(Class)
    # use sham
    attrs = self.sham("tools/#{name}").to_h
    return klass.new unless attrs

    klass.new do |i|
      attrs.each do |attr, value|
        i.public_send("#{attr}=", value)
      end
    end
  end
end
