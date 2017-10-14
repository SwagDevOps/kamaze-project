# frozen_string_literal: true

require 'swag_dev/project/tools'
require 'swag_dev/project/tools/packer/filesystem'
require 'swag_dev/project/tools/packer/command'
require 'pathname'
require 'cliver'

# Provides a ready to use interface based on rubyc (aka ruby-packer)
#
# Only gem can be "packed", out-of-the box
# this behavior SHOULD be overriden using a ``sham``
class SwagDev::Project::Tools::Packer
  # Get filesystem
  #
  # @return [SwagDev::Project::Tools::Packer::Filesystem]
  attr_reader :fs

  # Binary (executable) used to pack the project
  #
  # @see https://github.com/pmq20/ruby-packer
  attr_accessor :compiler

  def initialize
    @initialized = false
    @fs = Filesystem.new

    yield self if block_given?

    @initialized = true
    @compiler ||= :rubyc
  end

  # Denote class is initialized
  #
  # @return [Boolean]
  def initialized?
    @initialized
  end

  # Pack executables
  #
  # @return [Array<Pathname>]
  def pack_all
    prepare
    build_all
  end

  # @return [Array<Pathname>]
  def pack(executable)
    prepare
    [build(executable)]
  end

  def method_missing(method, *args, &block)
    if respond_to_missing?(method)
      fs.public_send(method, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(method, include_private = false)
    unless initialized? and method.to_s[-1] == '='
      return true if fs.respond_to?(method, include_private)
    end

    super(method, include_private)
  end

  protected

  # Build buildable
  #
  # @param [String] buildable
  # @return [Pathname]
  def build(buildable)
    Command.new do |command|
      command.executable = compiler
      command.pwd        = pwd
      command.src_dir    = build_dirs.fetch(:src)
      command.tmp_dir    = build_dirs.fetch(:tmp)
      command.bin_dir    = bin_dir
      command.buildable  = buildable
    end.execute

    bin_dir.join(buildable)
  end

  # Build executables
  #
  # @return [Array<Pathname>]
  def build_all
    buildables.to_a.clone.map { |buildable| build(buildable) }
  end
end
