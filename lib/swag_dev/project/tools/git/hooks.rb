# frozen_string_literal: true

require_relative '../git'
require 'swag_dev/project/concern/helper'

# Provide hooks
#
# Kind of factory registering and building hooks
class SwagDev::Project::Tools::Git::Hooks
  class << self
    include SwagDev::Project::Concern::Helper

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

  # @param [Rugged::Repository] repository
  def initialize(repository)
    @repository = repository
    @hooks = {}

    [:pre_commit].each { |n| self.class.register(n) }

    self.class.registered_hooks.each do |name, klass|
      @hooks[name] = klass.new(executable)
    end
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
end
