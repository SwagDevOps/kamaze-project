# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../hooks'
require_relative '../../../concern/cli/with_exit_on_failure'

# Base Hook
class Kamaze::Project::Tools::Git::Hooks::BaseHook
  include Kamaze::Project::Concern::Cli::WithExitOnFailure

  # @param [Kamaze::Project::Tools::Git] repository
  def initialize(repository)
    @repository = repository
  end

  protected

  # @return [Kamaze::Project::Tools::Git]
  attr_reader :repository
end
