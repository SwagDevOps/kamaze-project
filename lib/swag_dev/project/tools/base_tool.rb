# frozen_string_literal: true

require_relative '../tools'
require_relative '../observable'

class SwagDev::Project::Tools
  class BaseTool < SwagDev::Project::Observable
  end
end

# Provides base for tools
#
# @abstract
class SwagDev::Project::Tools::BaseTool
  def initialize
    dispatch_event(:before_setup)
    setup
    dispatch_event(:after_setup)

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
