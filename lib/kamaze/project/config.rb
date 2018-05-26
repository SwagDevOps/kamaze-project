# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../project'
require_relative 'struct'

# Generic config(urator) class
#
# @abstract Subclass and override {#defaults} to implement
class Kamaze::Project::Config
  # @return [Kamaze::Project::Struct]
  attr_reader :attributes

  def initialize
    @attributes = Kamaze::Project::Struct.new(defaults)
  end

  # Configure an object (manipulating its properties)
  #
  # @param [Object] configurable
  # @return [Object]
  def configure(configurable)
    to_h.each do |k, v|
      configurable.__send__("#{k}=", v)
    end

    configurable
  end

  # @return [Hash]
  def to_h
    attributes.to_h
  end

  def method_missing(method, *args, &block)
    if respond_to_missing?(method)
      @attributes.public_send(method, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(method, include_private = false)
    return true if attributes.respond_to?(method, include_private)

    super(method, include_private)
  end

  # @return [Hash]
  def defaults
    {}
  end
end
