# frozen_string_literal: true

require_relative '../hooks'

class SwagDev::Project::Tools::Git::Hooks
  class BaseHook
  end
end

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
