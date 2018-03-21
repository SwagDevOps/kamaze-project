# frozen_string_literal: true

# Object is the default root of all Ruby objects
#
# Object inherits from BasicObject
# which allows creating alternate object hierarchies.
# Methods on Object are available to all classes
# (unless explicitly overridden).
#
# @see https://ruby-doc.org/core-2.5.0/Object.html
class Object
  if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.5.0')
    # Yields self to the block and returns the result of the block.
    #
    # @return [Object]
    # @see https://ruby-doc.org/core-2.5.0/Object.html#method-i-yield_self
    def yield_self
      yield(self)
    end
  end
end
