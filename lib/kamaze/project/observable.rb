# frozen_string_literal: true

require_relative '../project'
require_relative 'concern/observable'
# implicitely require observer
require_relative 'observer'

# Observable provides the methods for managing the associated observers.
#
# @abstract
# @see Kamaze::Project::Concern::Observable
class Kamaze::Project::Observable
  include Kamaze::Project::Concern::Observable
end
