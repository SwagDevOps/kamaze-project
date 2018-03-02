# frozen_string_literal: true

require_relative '../tools'

# @abstract
class SwagDev::Project::Tools::BaseTool
  def initialize
    yield self if block_given?

    setup

    attrs_mute!
  end

  # Mutable attributes
  #
  # Mutable attributes become ``ro`` after initialization
  #
  # @return [Array]
  def mutable_attributes
    []
  end

  protected

  # Execute additionnal setup
  def setup
    nil
  end

  def attrs_mute!
    mutable_attributes.each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }
    end
  end
end
