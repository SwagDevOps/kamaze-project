# frozen_string_literal: true

require_relative 'files_array'

# rubocop:disable Style/Documentation
class SwagDev::Project::Tools::Git::Status
  class Worktree < FilesArray
    @type = :worktree
  end
end
# rubocop:enable Style/Documentation

# Represent files seen in worktree
class SwagDev::Project::Tools::Git::Status::Worktree
end
