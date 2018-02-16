# frozen_string_literal: true

require_relative 'files_array'
require_relative 'worktree'

# rubocop:disable Style/Documentation
class SwagDev::Project::Tools::Git::Status
  class Index < FilesArray
    @type = :index
  end
end
# rubocop:enable Style/Documentation

# Represent index status
class SwagDev::Project::Tools::Git::Status::Index
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

  # Get present files in intersection between index and worktree
  #
  # @todo only "modified" files SHOULD be considered
  # @return [Array<File>]
  def unsafe_files
    c = [self, worktree].map do |a|
      a.map { |f| f.absolute_path.to_s }
    end.freeze

    self.to_a.keep_if do |f|
      if (c[0] & c[1]).include?(f.absolute_path.to_s)
        true if f.index_modified? and f.worktree_modified?
      else
        false
      end
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
  # @return [SwagDev::Project::Tools::Git::Status::Worktree]
  def worktree
    memo = Array.new(memento)

    SwagDev::Project::Tools::Git::Status::Worktree.new(memo)
  end
end
