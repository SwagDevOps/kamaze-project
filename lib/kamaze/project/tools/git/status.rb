# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../git'
require_relative 'status/file'
require_relative 'status/index'
require_relative 'status/worktree'
require_relative 'status/decorator'
require 'pathname'

# Provide status
#
# Status can provide different kind of file lists, as seen by ``libgit``.
#
# ``index`` and ``worktree`` are directly provided throuh ``status``,
# but files can also been easily discriminated by status.
#
# @see Kamaze::Project::Tools::Git::Status::File
class Kamaze::Project::Tools::Git::Status
  # @return [Pathname]
  attr_reader :base_dir

  # @param [Hash{String => Array<Symbol>}] status
  # @param [String] base_dir
  def initialize(status, base_dir = Dir.pwd)
    @base_dir = ::Pathname.new(base_dir)
    @status = status.clone
    @cached = nil
  end

  # @return [Decorator]
  def decorate
    Decorator.new(self)
  end

  # @return [String]
  def to_s
    decorate.to_s
  end

  # Empty cache
  #
  # @return [self]
  def refresh!
    @cached = nil

    self
  end

  # Get index
  #
  # @return [Index]
  def index
    Index.new(self.to_a)
  end

  # Get worktree
  #
  # @return [Worktree]
  def worktree
    Worktree.new(self.to_a)
  end

  # @return [Array<File>]
  def to_a
    cached.to_a.map { |v| File.new(v.fetch(0), v.fetch(1), base_dir) }
  end

  protected

  # Get cached filepaths
  #
  # @return [Hash]
  def cached
    @cached ||= prepared

    @cached
  end

  # Get prepared filepaths with symbols (states)
  #
  # @return [Hash{String => Hash{Symbol => Symbol}}]
  def prepared
    output = {}
    @status.each do |file, status_data|
      status_data.each do |status|
        status = status.to_s.split('_').map(&:to_sym)
        flags = { status[0] => status[1] || status[0] }

        output[file] = (output[file] || {}).merge(flags)
      end
    end

    output
  end
end
