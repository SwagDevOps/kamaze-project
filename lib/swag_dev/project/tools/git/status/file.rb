# frozen_string_literal: true

require_relative '../status'
require 'pathname'

# Status file
#
# Describe a file as seen in status,
# file is described by its path and its flag.
# File is immutable by design.
#
# @see https://git-scm.com/docs/git-status
class SwagDev::Project::Tools::Git::Status::File
  # @return [Pathname]
  attr_reader :base

  # @return [Pathname]
  attr_reader :path

  # @return [String]
  attr_reader :flag

  # @param [Pathname|String] path
  # @param [String] flag
  # @param [Pathname|String] base
  def initialize(path, flag, base = Dir.pwd)
    @base = ::Pathname.new(base).freeze
    @path = ::Pathname.new(path).freeze
    @flag = flag.split('').freeze
  end

  def deleted?
    flag.include?('D')
  end

  def staged?
    !['?', '!', ' '].include?(flag[0])
  end

  def untracked?
    flag[0] == '?'
  end

  def unmerged?
    flag.each { |f| return true if ['D', 'A', 'U'].include?(f) }

    false
  end

  def ignored?
    flag[0] == '!'
  end

  def modified?
    flag.include?('M')
  end

  def renamed?
    flag.include?('R')
  end

  def copied?
    flag.include?('C')
  end

  def to_s
    absolute_path.to_s
  end

  # Status line
  #
  # String representation for file status as a string line
  #
  # @return [String]
  def status_line
    path = self.path
    if flag[0] == '?' and path.dirname.to_s != '.'
      path = path.dirname
      path = "#{path}/" if path.directory?
    end

    "#{flag.join} #{path}"
  end

  # Get absolute path
  #
  # @return [Pathname]
  def absolute_path
    base.join(path)
  end
end
