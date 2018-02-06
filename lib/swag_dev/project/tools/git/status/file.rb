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
  attr_reader :base_dir

  # @return [Pathname]
  attr_reader :path

  # @return [String]
  attr_reader :flags

  # @param [Pathname|String] path
  # @param [String] flag
  # @param [Pathname|String] base
  def initialize(path, flags, base_dir = Dir.pwd)
    @base_dir = ::Pathname.new(base_dir).freeze
    @path = ::Pathname.new(path).freeze
    @flags = flags.to_a.map(&:to_sym)
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
    base_dir.join(path)
  end
end
