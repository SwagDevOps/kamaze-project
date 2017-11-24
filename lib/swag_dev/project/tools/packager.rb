# frozen_string_literal: true

require 'swag_dev/project/tools'

# rubocop:disable Style/Documentation
class SwagDev::Project::Tools::Packager
  class Filesystem
    class Operator
      module Utils
      end
    end
  end

  require_relative 'packager/filesystem'
  require_relative 'packager/filesystem/operator'
  require_relative 'packager/filesystem/operator/utils'
end # rubocop:enable Style/Documentation

# Provides a packager
#
# Packager is intended to provide basic packaging operations
# @abstract
class SwagDev::Project::Tools::Packager
  # Get filesystem
  #
  # @return [SwagDev::Project::Tools::Packager::Filesystem]
  attr_reader :fs

  def initialize
    @initialized = false
    yield self if block_given?

    @fs ||= self.class.const_get(:Filesystem).new
    setup

    @initialized = true
    attrs_mute!
  end

  # Denote class is initialized
  #
  # @return [Boolean]
  def initialized?
    @initialized
  end

  # Mutable attributes
  #
  # Mutable attributes become ``protected`` after initialization
  #
  # @return [Array]
  def mutable_attributes
    []
  end

  def method_missing(method, *args, &block)
    if respond_to_missing?(method)
      unless initialized?
        mutable = fs.mutable_attribute?(method)

        return fs.__send__(method, *args, &block) if mutable
      end

      return fs.public_send(method, *args, &block)
    end

    super
  end

  def respond_to_missing?(method, include_private = false)
    if method.to_s[-1] == '='
      unless initialized?
        return true if fs.mutable_attribute?(method)
      end
    end

    return true if fs.respond_to?(method, include_private)

    super(method, include_private)
  end

  protected

  # Execute additionnal setup
  def setup
  end

  def attrs_mute!
    mutable_attributes.each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }
    end
  end
end
