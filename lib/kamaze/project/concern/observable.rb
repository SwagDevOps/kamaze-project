# frozen_string_literal: true

require_relative '../concern'

# Observable provides the methods for managing the associated observers.
#
# The observers SHOULD implement a method called ``update``
# to receive notifications.
#
# The observable object MNUST:
#
# * call ``#dispatch_event``
#
# Sample of use:
#
# ```ruby
# # @abstract
# class Observable
#   include Kamaze::Project::Concern::Observable
# end
#
# class Subject < Observable
#  attr_accessor :updated_at
#
#   def update
#     # do something
#     dispatch_event(:after_update)
#   end
# end
#
# class SubjectObserver < Kamaze::Project::Observer
#   observe Subject
#
#   def after_update(subject)
#     subject.updated_at = Time.now
#   end
# end
# ```
module Kamaze::Project::Concern::Observable
  class << self
    def included(base)
      base.extend(ClassMethods)
    end
  end

  # Class methods
  module ClassMethods
    # Add observer.
    #
    # @param [Class] observer_class
    # @return [self]
    def add_observer(observer_class, func = :handle_event)
      @observer_peers ||= {}
      func = func.to_sym

      unless observer_class.instance_methods.include?(func)
        m = "#<#{observer_class}> does not respond to `#{func}'"
        raise NoMethodError, m
      end

      @observer_peers[observer_class] = func

      self
    end

    # Remove observer, so that it will no longer receive notifications.
    #
    # @param [Class] observer_class
    # @return [self]
    def delete_observer(observer_class)
      observer_peers.delete(observer_class)

      return self
    end

    # Remove all observers.
    #
    # @return [self]
    def delete_observers
      observers.clear

      self
    end

    protected def observer_peers
      @observer_peers || {}
    end
  end

  def initialize
    initialize_observers
  end

  protected

  # @return [Hash|nil]
  attr_reader :observer_peers

  # Initialize observers (as seen in ``self.class.observer_peers``)
  #
  # @return [self]
  def initialize_observers
    @observer_peers ||= {}

    self.class.__send__(:observer_peers).to_h.each do |k, v|
      @observer_peers[k.new] = v
    end

    self
  end

  # Dispatch given ``event``
  #
  # @param [Symbol|String] event
  # @param [Array<Object>] args
  # @return [self]
  def dispatch_event(event, *args)
    observer_peers.to_h.each do |k, v|
      k.__send__(v, *[event, self].concat(args))
    end

    self
  end
end
