# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../git'

# Provide base class for utils based on git
#
# Provide access to the repository
# @see http://www.rubydoc.info/github/libgit2/rugged/Rugged/Repository
#
# @abstract
class Kamaze::Project::Tools::Git::Util
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
