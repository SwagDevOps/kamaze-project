# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative 'files_array'

class Kamaze::Project::Tools::Git::Status
  class Worktree < FilesArray
  end
end

# Represent worktree status
class Kamaze::Project::Tools::Git::Status::Worktree
  @type = :worktree
end
