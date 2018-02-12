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
  # Denote index is tainted
  #
  # Tainted index shares modifications with the worktree,
  # thus, files CAN NOT be naively verified.
  # For example running a static code analysis on files seen
  # in a tainted index COULD lead to inconsistent results.
  #
  # @return [Boolean]
  def tainted?
    tainted_files.empty? ? false : true
  end

  # Get present files in intersection between index and worktree
  #
  # @todo only "modified" files SHOULD be considered
  # @return [Array<File>]
  def tainted_files
    c = [self.to_a, worktree].map do |a|
      a.map { |f| f.absolute_path.to_s }
    end.freeze

    self.to_a.keep_if do |f|
      (c[0] & c[1]).include?(f.absolute_path.to_s)
    end
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
