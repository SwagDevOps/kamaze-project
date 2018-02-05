# frozen_string_literal: true

require_relative '../git'

# Provide base class for utils based on git
#
# Provide access to the repository
# @see http://www.rubydoc.info/github/libgit2/rugged/Rugged/Repository
#
# @abstract
class SwagDev::Project::Tools::Git::Util
  attr_reader :repository

  # @param [Rugged::Repository] repository
  def initialize(repository)
    @repository = repository

    setup
  end

  protected

  # Setup
  #
  # Almost used for inheritance
  def setup
    nil
  end
end
