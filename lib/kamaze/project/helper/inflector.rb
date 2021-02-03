# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../helper'

# Inflector built on top of ``Dry::Inflector``
class Kamaze::Project::Helper::Inflector < Kamaze::Project::Inflector
  # Load constant from a loadable/requirable path
  #
  # @param [String] loadable
  # @return [Object]
  #
  # @raise LoadError
  # @raise TypeError
  def resolve(loadable)
    (loadable.to_s.empty? ? nil : loadable.to_s).yield_self do |f|
      require f
      self.constantize(self.classify(f))
    end
  end
end
