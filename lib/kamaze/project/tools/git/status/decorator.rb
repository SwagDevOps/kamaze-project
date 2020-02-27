# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../status'

# Provide decoration for status
#
# Result of ``to_s``, SHOULD be similar to result obtained with:
#
# ```sh
# git status -z | sed "s/\x0/\n/g"
# ```
class Kamaze::Project::Tools::Git::Status::Decorator
  # @param [Kamaze::Project::Tools::Git::Status] status
  def initialize(status)
    @status = status
  end

  def files
    files = [status.index.to_a, status.worktree.to_a].flatten.sort_by(&:to_s)

    files.reject(&:untracked?)
         .concat(files.keep_if(&:untracked?))
  end

  def to_s
    files.map { |file| "#{file.status} #{file}" }.uniq.join("\n")
  end

  protected

  # @return [Kamaze::Project::Tools::Git::Status]
  attr_reader :status
end
