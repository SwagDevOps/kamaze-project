# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../project'

# Observer class
#
# @abstract
# @see Kamaze::Project::Observable
# @see Kamaze::Project::Concern::Observable
class Kamaze::Project::Observer
  class << self
    # Subscribe to given class.
    #
    # @param [Class] observed_class
    # @return [self]
    def observe(observed_class, func = nil)
      observed_class.add_observer(*[self, func].compact)

      self
    end
  end

  # Callback for observer.
  #
  # @return [self]
  def handle_event(func, *args)
    self.__send__(func, *args) if self.respond_to?(func, true)

    self
  end
end
