# frozen_string_literal: true

require_relative '../project'
require_relative 'concern/observable'

class Kamaze::Project
  # Observable provides the methods for managing the associated observers.
  #
  #
  # @abstract
  # @see [Kamaze::Project::Concern::Observable]
  class Observable
    include Kamaze::Project::Concern::Observable
  end
end
