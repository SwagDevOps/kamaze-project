# frozen_string_literal: true

require_relative '../project'
require_relative 'concern/observable'

class SwagDev::Project
  # Observable provides the methods for managing the associated observers.
  #
  #
  # @abstract
  # @see [SwagDev::Project::Concern::Observable]
  class Observable
    include SwagDev::Project::Concern::Observable
  end
end
