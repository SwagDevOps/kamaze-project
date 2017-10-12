# frozen_string_literal: true

require 'swag_dev/project/tools'
require 'swag_dev/project/tools/packer/filesystem'
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
  attr_writer :compiler

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

  # Get compiler (binary executable)
  #
  # @return [Pathname]
  def compiler
    Pathname.new(Cliver.detect!(@compiler))
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

  # Make command to pack a given executable
  #
  # @param [String] executable
  # @return [Array<String>]
  def make_command(buildable)
    buildable = Pathname.new(buildable)
    tmp_dir = pwd.join(build_dirs.fetch(:tmp))

    [compiler,
     bin_dir.join(buildable.basename),
     '-r', '.',
     '-d', tmp_dir.to_s,
     '-o', pwd.join(buildable)].map(&:to_s)
  end

  # Build executable
  #
  # @param [String] executable
  # @return [Pathname]
  def build(buildable)
    Dir.chdir(pwd.join(build_dirs.fetch(:src))) do
      Bundler.with_clean_env do
        sh(*([ENV.to_h] + make_command(buildable)))
      end
    end

    bin_dir.join(buildable)
  end

  # Build executables
  #
  # @return [Array<Pathname>]
  def build_all
    buildables.to_a.clone.map { |buildable| build(buildable) }
  end
end
