# frozen_string_literal: true

require_relative '../project'

class Kamaze::Project
  class Observer
  end
end

# Observer class
#
# @abstract
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
    self.public_send(func, *args) if self.respond_to?(func)

    self
  end
end
