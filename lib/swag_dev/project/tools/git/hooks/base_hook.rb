# frozen_string_literal: true

require_relative '../hooks'
require_relative '../../../concern/cli/with_exit_on_failure'

# rubocop:disable Style/Documentation

class SwagDev::Project::Tools::Git::Hooks
  class BaseHook
    include SwagDev::Project::Concern::Cli::WithExitOnFailure
  end
end

# rubocop:enable Style/Documentation

# Base Hook
class SwagDev::Project::Tools::Git::Hooks::BaseHook
  # @param [SwagDev::Project::Tools::Git] repository
  def initialize(repository)
    @repository = repository
  end

  protected

  # @return [SwagDev::Project::Tools::Git]
  attr_reader :repository
end
