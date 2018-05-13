# frozen_string_literal: true

require_relative '../hooks'
require_relative '../../../concern/cli/with_exit_on_failure'

# rubocop:disable Style/Documentation

class Kamaze::Project::Tools::Git::Hooks
  class BaseHook
    include Kamaze::Project::Concern::Cli::WithExitOnFailure
  end
end

# rubocop:enable Style/Documentation

# Base Hook
class Kamaze::Project::Tools::Git::Hooks::BaseHook
  # @param [Kamaze::Project::Tools::Git] repository
  def initialize(repository)
    @repository = repository
  end

  protected

  # @return [Kamaze::Project::Tools::Git]
  attr_reader :repository
end
