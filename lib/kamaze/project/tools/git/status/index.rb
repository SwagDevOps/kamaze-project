# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative 'files_array'
require_relative 'worktree'

# rubocop:disable Style/Documentation

class Kamaze::Project::Tools::Git::Status
  class Index < FilesArray
    @type = :index
  end
end

# rubocop:enable Style/Documentation

# Represent index status
class Kamaze::Project::Tools::Git::Status::Index
  # Denote index is safe
  #
  # Unsafe index shares modifications with the worktree,
  # thus, files SHOULD NOT be naively analyzed,
  # for example, by running a static code analysis.
  # Running a static code analysis on unsafe index files
  # COULD lead to inconsistent results.
  #
  # @return [Boolean]
  def safe?
    unsafe_files.empty?
  end

  # @return [Boolean]
  def unsafe?
    !safe?
  end

  # Get present files in intersection between index and worktree
  #
  # @return [Array<File>]
  def unsafe_files
    c = [self, worktree].map do |a|
      a.map { |f| f.absolute_path.to_s }
    end.freeze

    self.to_a.keep_if do |f|
      (c[0] & c[1]).include?(f.absolute_path.to_s)
    end
  end

  # Get files present in index and considered as safe
  #
  # Safe files SHOULD NOT present divergent modifications
  # between index and worktree. As seen in ``unsafe_files`` only
  # the modified state is considered.
  def safe_files
    unsafe = self.unsafe_files.map { |f| f.absolute_path.to_s }

    self.to_a
        .reject { |f| unsafe.include?(f.absolute_path.to_s) }
  end

  protected

  # Get a fresh (not frozen) copy of worktree as seen on initialization
  #
  # @return [Kamaze::Project::Tools::Git::Status::Worktree]
  def worktree
    memo = Array.new(memento)

    Kamaze::Project::Tools::Git::Status::Worktree.new(memo)
  end
end
