# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

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
    #
    # @return [self]
    def add_observer(observer_class, func = :handle_event)
      func = func.to_sym

      unless observer_class.instance_methods.include?(func)
        m = "#<#{observer_class}> does not respond to `#{func}'"
        raise NoMethodError, m
      end

      observer_peers[observer_class] = func

      self
    end

    # Remove observer, so that it will no longer receive notifications.
    #
    # @param [Class] observer_class
    #
    # @return [self]
    def delete_observer(observer_class)
      self.tap do
        observer_peers.delete(observer_class)
      end
    end

    # Remove all observers.
    #
    # @return [self]
    def delete_observers
      self.tap { observers.clear }
    end

    protected

    # @return [Hash]
    def observer_peers
      @observer_peers ||= {}
    end
  end

  def initialize
    observer_peers_initialize
  end

  protected

  # @return [Hash|nil]
  attr_reader :observer_peers

  # Initialize observers (defined from ``self.class.observer_peers``)
  #
  # @return [self]
  def observer_peers_initialize
    (@observer_peers ||= {}).yield_self do |observer_peers|
      self.class.__send__(:observer_peers).to_h.each do |k, v|
        observer_peers[k.new] = v
      end
    end

    self
  end

  # Dispatch given ``event``
  #
  # @param [Symbol|String] event
  # @param [Array<Object>] args
  #
  # @return [self]
  def dispatch_event(event, *args)
    self.tap do
      observer_peers.to_h.each do |k, v|
        k.__send__(v, *[event, self].concat(args))
      end
    end
  end
end
