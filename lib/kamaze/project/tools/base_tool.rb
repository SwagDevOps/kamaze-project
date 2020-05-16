# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../tools'

# Provides base for tools
#
# @abstract
class Kamaze::Project::Tools::BaseTool < Kamaze::Project::Observable
  def initialize
    super()

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
  # @abstract
  def mutable_attributes
    []
  end

  protected

  # Execute additionnal setup
  #
  # @abstract
  def setup
    nil
  end

  # Mut(at)e attributes
  #
  # After initialization, attributes given has mutable
  # become ``ro`` (protected setter)
  #
  # @return [self]
  def attrs_mute!
    mutable_attributes.each do |m|
      # rubocop:disable Style/AccessModifierDeclarations
      self.singleton_class.class_eval { protected "#{m}=" }
      # rubocop:enable Style/AccessModifierDeclarations
    end

    self
  end
end
