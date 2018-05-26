# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require 'kamaze/project'
require 'singleton'

# Provides access to helper classes
class Kamaze::Project::Helper
  include ::Singleton

  class << self
    attr_reader :ns
  end

  @ns = :'kamaze/project/helper'

  # @param [String|Symbol] name
  # @return [Object]
  #
  # @raise [NotImplementedError]
  def get(name)
    name = name.to_sym

    return items[name] if items[name]

    begin
      @items[name] = inflector.resolve("#{self.class.ns}/#{name}").new
    rescue LoadError
      raise NotImplementedError, "helper not loadable: #{name}"
    end
  end

  protected

  attr_reader :items

  def initialize
    @items = {
      inflector: proc do
        require "#{self.class.ns}/inflector"

        Inflector.new
      end.call
    }

    super
  end

  # @return [Hash]
  def to_h
    items
  end

  # @return [Sys::Proc::Helper::Inflector]
  def inflector
    to_h.fetch(:inflector)
  end
end
