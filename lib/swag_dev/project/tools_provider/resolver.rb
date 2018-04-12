# frozen_string_literal: true

require_relative '../tools_provider'
require_relative '../../project/concern/helper'

class SwagDev::Project::ToolsProvider
  class Resolver
  end
end

# Provide class name resolution
class SwagDev::Project::ToolsProvider::Resolver
  include SwagDev::Project::Concern::Helper

  def initialize
    # @type [SwagDev::Project::Helper::Inflector]
    @inflector = helper.get(:inflector)
  end

  # Resolve given class path
  #
  # @see SwagDev::Project::Helper::Inflector
  # @param [Symbol|String] klass
  # @return [Class]
  def resolve(klass)
    @inflector.resolve(klass)
  end

  # Retrieve ``Class`` if necessary with given identifier
  #
  # @param [String|Symbol|Class] klass
  # @return [Class]
  def classify(klass)
    klass.is_a?(Class) ? klass : self.resolve(klass)
  end
end
