# frozen_string_literal: true

require_relative '../status'
require 'pathname'

# Status file
#
# Describe a file as seen in status,
# file is described by path and flags, and is immutable by design.
#
# @see http://www.rubydoc.info/github/libgit2/rugged/Rugged%2FRepository%3Astatus
class SwagDev::Project::Tools::Git::Status::File
  # @return [Pathname]
  attr_reader :base_dir

  # @return [Pathname]
  attr_reader :path

  # @return [String]
  attr_reader :flags

  # @param [Pathname|String] path
  # @param [Hash] flags
  # @param [Pathname|String] base_dir
  def initialize(path, flags, base_dir = Dir.pwd)
    @base_dir = ::Pathname.new(base_dir).freeze
    @path = ::Pathname.new(path).freeze
    @flags = flags.freeze
  end

  # @return [String]
  def to_s
    path.to_s
  end

  # Get a status string, composed of two chars
  #
  # @see https://git-scm.com/docs/git-status
  # @return [String]
  def status
    return '??' if untracked?
    states = [' ', ' ']
    mapping = { new: 'A', modified: 'M', deleted: 'D' }
    { index: 0, worktree: 1 }.each do |from, index|
      next unless self.public_send("#{from}?")

      mapping.each do |flag, s|
        states[index] = s if self.public_send("#{from}_#{flag}?")
      end
    end

    states.join
  end

  # @return [Boolean]
  def ==(other)
    return false unless comparable_with?(other)

    [[self.path.to_s, other.path.to_s],
     [self.base_dir.to_s, other.base_dir.to_s],
     [self.flags.sort, other.flags.sort]].each do |c|
      return false unless c[0] == c[1]
    end

    true
  end

  # Denote instance is comparable with another object
  #
  # @param [Object] other
  # @return [Boolean]
  def comparable_to?(other)
    [:flags, :path, :base_dir]
      .map { |m| other.respond_to?(m) }.uniq == [true]
  end

  # Get absolute path
  #
  # @return [Pathname]
  def absolute_path
    base_dir.join(path)
  end

  # Denote ignored
  #
  # @return [Boolean]
  def ignored?
    flags.keys.include?(:ignored)
  end

  # Denote worktree
  #
  # @return [Boolean]
  def worktree?
    flags.keys.include?(:worktree)
  end

  # Denote index
  #
  # @return [Boolean]
  def index?
    flags.keys.include?(:index)
  end

  # Denote new
  #
  # @return [Boolean]
  def new?
    flags.values.include?(:new)
  end

  # Denote modified
  #
  # @return [Boolean]
  def modified?
    flags.values.include?(:modified)
  end

  # Denote deleted
  #
  # @return [Boolean]
  def deleted?
    flags.values.include?(:deleted)
  end

  # Denote untracked
  #
  # @return [Boolean]
  def untracked?
    worktree? and new? and !index?
  end

  # Denote new in index
  #
  # @return [Boolean]
  def index_new?
    index? and new?
  end

  # Denote modified in index
  #
  # @return [Boolean]
  def index_modified?
    index? and modified?
  end

  # Denote deleted in index
  #
  # @return [Boolean]
  def index_deleted?
    index? and deleted?
  end

  # Denote new in worktree
  #
  # @return [Boolean]
  def worktree_new?
    worktree? and new?
  end

  # Denote modified in worktree
  #
  # @return [Boolean]
  def worktree_modified?
    worktree? and modified?
  end

  # Denote deleted in worktree
  #
  # @return [Boolean]
  def worktree_deleted?
    worktree? and deleted?
  end
end
