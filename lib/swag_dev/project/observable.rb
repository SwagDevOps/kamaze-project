# frozen_string_literal: true

require_relative '../project'

class SwagDev::Project
  class Observable
  end
end

# Observable provides the methods for managing the associated observers.
#
# The observers SHOULD implement a method called ``update``
# to receive notifications.
#
# The observable object MNUST:
#
# * call ``#dispatch_event``
#
# @abstract
class SwagDev::Project::Observable
  class << self
    # @return [Hash|nil]
    attr_reader :observers

    # Add observer.
    #
    # @param [Class] observer_class
    # @return [self]
    def add_observer(observer_class, func = :handle_event)
      @observers ||= {}
      func = func.to_sym

      unless observer_class.instance_methods.include?(func)
        m = "#<#{observer_class}> does not respond to `#{func}'"
        raise NoMethodError, m
      end

      @observers[observer_class] = func

      self
    end

    # Remove observer, so that it will no longer receive notifications.
    #
    # @param [Class] observer_class
    # @return [self]
    def delete_observer(observer_class)
      observers.delete(observer_class)

      return self
    end

    # Remove all observers.
    #
    # @return [self]
    def delete_observers
      observers.clear

      self
    end
  end

  def initialize
    initialize_observers
  end

  protected

  attr_reader :observers

  def initialize_observers
    @observers ||= {}

    self.class.observers.each do |k, v|
      @observers[k.new] = v
    end

    self
  end

  def dispatch_event(event, *args)
    return self if self.class.observers.to_h.empty?

    observers.to_h.each do |k, v|
      k.__send__(*[event, self].concat(args))
    end

    self
  end
end
