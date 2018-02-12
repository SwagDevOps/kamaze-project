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

  class << self
    # Available status flags
    #
    # @return [Array<Symbol>]
    def flags
      [:index, :worktree, :ignored, :new, :modified, :deleted]
    end
  end

  # @param [Pathname|String] path
  # @param [String] flag
  # @param [Pathname|String] base
  def initialize(path, flags, base_dir = Dir.pwd)
    @base_dir = ::Pathname.new(base_dir).freeze
    @path = ::Pathname.new(path).freeze
    @flags = flags.to_a.map(&:to_sym)
  end

  # @return [String]
  def to_s
    path.to_s
  end

  # @return [Boolean]
  def ==(other)
    return false unless comparable_with?(other)

    [[self.flags.sort, other.flags.sort],
     [self.path.to_s, other.path.to_s],
     [self.base_dir.to_s, other.base_dir.to_s]].each do |c|
      return false unless c[0] == c[1]
    end

    true
  end

  # Denote instance is comparable with another object
  #
  # @param [Object] other
  # @return [Boolean]
  def comparable_to?(other)
    [:flags, :path, :base_dir].map { |m| other.respond_to?(m) }.uniq[0]
  end

  # Get absolute path
  #
  # @return [Pathname]
  def absolute_path
    base_dir.join(path)
  end

  # @!method igmored?
  #   Denote ignored
  #   @return [Boolean]

  # @!method worktree?
  #   Denote worktree
  #   @return [Boolean]

  # @!method index?
  #   Denote index
  #   @return [Boolean]

  # @!method new?
  #   Denote new
  #   @return [Boolean]

  # @!method modified?
  #   Denote modified
  #   @return [Boolean]

  # @!method deleted?
  #   Denote deleted
  #   @return [Boolean]

  def method_missing(method, *args, &block)
    return super unless respond_to_missing?(method)

    flags.include?(method.to_s.gsub(/\?$/, '').to_sym)
  end

  def respond_to_missing?(method, include_private = false)
    if method.to_s =~ /.+\?$/
      flag = method.to_s.gsub(/\?$/, '').to_sym
      return self.class.flags.include?(flag)
    end

    super(method, include_private)
  end
end
