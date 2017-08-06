# frozen_string_literal: true

require 'swag_dev/project'
require 'singleton'

# Provides access to helper classes
class SwagDev::Project::Helper
  include ::Singleton

  protected def initialize
    @items = {
      inflector: proc do
        require 'swag_dev/project/helper/inflector'

        Inflector.new
      end.call
    }

    super
  end

  # @param [String|Symbol] name
  # @return [Object]
  #
  # @raise [NotImplementedError]
  def get(name)
    name = name.to_sym

    return items[name] if items[name]

    begin
      @items[name] = inflector.resolve("swag_dev/project/helper/#{name}").new
    rescue LoadError
      raise NotImplementedError, "helper not loadable: #{name}"
    end
  end

  protected

  attr_reader :items

  # @return [Hash]
  def to_h
    items
  end

  # @return [Sys::Proc::Helper::Inflector]
  def inflector
    to_h.fetch(:inflector)
  end
end
