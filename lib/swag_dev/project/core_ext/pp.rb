# frozen_string_literal: true

require 'swag_dev/project/concern/debug'

# Object is the default root of all Ruby objects
#
# Object inherits from BasicObject
# which allows creating alternate object hierarchies.
# Methods on Object are available to all classes
# (unless explicitly overridden).
#
# @see https://ruby-doc.org/core-2.5.0/Object.html
class Object
  include SwagDev::Project::Concern::Debug
end
