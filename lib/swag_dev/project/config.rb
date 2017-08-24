# frozen_string_literal: true

require 'swag_dev/project'
require 'swag_dev/project/struct'

# Generic config(urator) class
#
# @abstract Subclass and override {#defaults} to implement
class SwagDev::Project::Config
  # @return [SwagDev::Project::Struct]
  attr_accessor :attributes

  def initialize
    @attributes = SwagDev::Project::Struct.new(defaults)
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
