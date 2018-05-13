# frozen_string_literal: true

require_relative 'files_array'

class Kamaze::Project::Tools::Git::Status
  class Worktree < FilesArray
  end
end

# Represent worktree status
class Kamaze::Project::Tools::Git::Status::Worktree
  @type = :worktree
end
