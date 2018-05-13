# frozen_string_literal: true

require_relative '../git'
require_relative 'hooks/base_hook'
require 'kamaze/project/concern/helper'

# Provide hooks
#
# Kind of factory registering and building hooks
class Kamaze::Project::Tools::Git::Hooks
  class << self
    include Kamaze::Project::Concern::Helper

    attr_reader :registered_hooks

    def register(name, klass = nil)
      klass ||= proc do
        cname = helper.get(:inflector).classify(name.to_s)

        require_relative "hooks/#{name}"

        helper.get(:inflector).constantize("#{self.name}::#{cname}")
      end.call

      @registered_hooks ||= {}
      @registered_hooks[name] = klass
      self
    end
  end

  @registered_hooks = {}

  # @param [Kamaze::Project::Tools::Git] repository
  def initialize(repository)
    @hooks = {}
    @repository = repository

    [:pre_commit].each { |n| self.class.register(n) }

    self.class
        .registered_hooks
        .each { |name, klass| @hooks[name] = klass.new(repository) }
  end

  # @return [Hash]
  def to_h
    @hooks.freeze
  end

  # @param [Symbol] key
  # @return [nil|Array<Hook>]
  def [](key)
    to_h[key]
  end

  protected

  # @return [Kamaze::Project::Tools::Git]
  attr_reader :repository
end
