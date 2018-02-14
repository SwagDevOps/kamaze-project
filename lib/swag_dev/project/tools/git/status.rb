# frozen_string_literal: true

require_relative '../git'
require_relative 'status/file'
require_relative 'status/index'
require_relative 'status/worktree'
require 'pathname'

# Provide status
class SwagDev::Project::Tools::Git::Status
  # @return [Pathname]
  attr_reader :base_dir

  # @param [Hash{String => Array<Symbol>}] status
  # @param [String] base_dir
  def initialize(status, base_dir = Dir.pwd)
    @base_dir = ::Pathname.new(base_dir)
    @status = status.clone
    @cached = nil
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
  # @return [Hash|nil]
  def cached
    @cached ||= prepared

    @cached
  end

  # Get prepared filepaths with symbols (states)
  #
  # @return [Hash{String => Array<Symbol>}]
  def prepared
    output = {}
    @status.each do |file, status_data|
      status_data.each do |status|
        status = status.to_s.split('_').map(&:to_sym)

        output[file] = (output[file] || []).concat(status).uniq.sort
      end
    end

    output
  end
end
