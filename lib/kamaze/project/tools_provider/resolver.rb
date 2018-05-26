# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../tools_provider'
require_relative '../../project/concern/helper'

class Kamaze::Project::ToolsProvider
  class Resolver
  end
end

# Provide class name resolution
class Kamaze::Project::ToolsProvider::Resolver
  include Kamaze::Project::Concern::Helper

  def initialize
    # @type [Kamaze::Project::Helper::Inflector]
    @inflector = helper.get(:inflector)
  end

  # Resolve given class path
  #
  # @see Kamaze::Project::Helper::Inflector
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
