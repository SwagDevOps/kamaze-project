# frozen_string_literal: true

require_relative '../packager'
require_relative 'filesystem/operator'
require 'pathname'

# Filesystem description used during build/packaging
#
# Filesystem has an Operator, which is intended to manipulate
# described files and directories.
# Build (issued from packaging) has a name, see ``build_name``,
# build name SHOULD be constitued with two (path) parts.
# Build dirs are labeled, as a default, only ``:src`` is provided.
# Labels are used to constitute the complete directory path
# (relative to ``pwd``).
class SwagDev::Project::Tools::Packager::Filesystem
  # Build dir (root directory)
  #
  # Relative to current pwd
  #
  # @type [String]
  attr_writer :build_basedir

  # Working directory
  #
  # @type [String]
  attr_writer :working_dir

  # @type [Array<String|Pathname>]
  attr_writer :source_files

  # Name given to the build
  #
  # @type [String]
  attr_accessor :build_name

  # Labels for build stages
  #
  # @type [Array<Symbol>]
  attr_writer :build_labels

  def initialize
    @build_basedir = 'build'
    @build_name    = 'sample/package'

    @working_dir   = Dir.pwd
    @operator      = self.operator
    @build_labels  = [:src]

    yield self if block_given?

    @source_files ||= []

    alter_attributes!
  end

  # Get build dir (root directory)
  #
  # @return [Pathname]
  def build_basedir
    ::Pathname.new(@build_basedir)
  end

  # Get build dir identified by its name
  #
  # @return [Pathname]
  def build_dir
    build_basedir.join(build_name)
  end

  # Get (named) paths for build dirs (as: src, tmp and bin)
  #
  # @return [Hash]
  def build_dirs
    @build_labels.map do |k, str|
      [k, build_dir.join(k.to_s)]
    end.to_h
  end

  # Get (original) working dir
  #
  # @return [Pathname]
  def working_dir
    ::Pathname.new(@working_dir)
  end

  alias pwd working_dir

  # Get source files
  #
  # @return [Array<Pathname>]
  def source_files
    @source_files.sort.map { |path| ::Pathname.new(path) }
  end

  def method_missing(method, *args, &block)
    if respond_to_missing?(method)
      operator.public_send(method, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(method, include_private = false)
    return true if operator.respond_to?(method, include_private)

    super(method, include_private)
  end

  protected

  # Get operator
  #
  # @return [SwagDev::Project::Tools::Packager::Filesystem::Operator]
  def operator
    @operator ||= self.class.const_get(:Operator).new(self)

    @operator
  end

  # Pass some attributes to protected
  #
  # @return [self]
  def alter_attributes!
    [
      :working_dir,
      :source_files,
      :build_basedir,
      :build_name,
      :build_labels
    ].each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }
    end

    self
  end
end
