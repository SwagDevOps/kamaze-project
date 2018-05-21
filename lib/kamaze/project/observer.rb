# frozen_string_literal: true

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
