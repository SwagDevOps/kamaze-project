# frozen_string_literal: true

require_relative '../packager'
require_relative 'filesystem/operator'
require 'pathname'

# Filesystem description used during packaging
#
# Filesystem has an Operator, which is intended to manipulate
# described files and directories.
# Package has a name, see ``package_name``,
# package name SHOULD be constitued with two (_path_) parts.
# Package dirs are labeled, as a default, only ``:src`` is provided.
# Labels are used to constitute the complete directory path
# (relative to ``pwd``).
class SwagDev::Project::Tools::Packager::Filesystem
  # Package dir (root directory)
  #
  # Relative to current pwd
  #
  # @type [String]
  attr_writer :package_basedir

  # Working directory
  #
  # @type [String]
  attr_writer :working_dir

  # @type [Array<String|Pathname>]
  attr_writer :source_files

  # Name given to the package
  #
  # @type [String]
  attr_accessor :package_name

  # Labels for packaging stages
  #
  # @type [Array<Symbol>]
  attr_writer :package_labels

  def initialize
    @package_basedir = 'build'
    @package_name    = 'sample/package'

    @working_dir     = Dir.pwd
    @operator        = self.operator
    @package_labels  = [:src]

    yield self if block_given?

    @source_files ||= []

    mute_attributes!(mutable_attributes)
  end

  # Get packaging dir (root directory)
  #
  # @return [Pathname]
  def package_basedir
    ::Pathname.new(@package_basedir)
  end

  # Get package dir identified by its name
  #
  # @return [Pathname]
  def package_dir
    package_basedir.join(package_name)
  end

  # Get (named) paths (as: src, tmp and bin)
  #
  # @return [Hash]
  def package_dirs
    @package_labels.map do |k, str|
      [k, package_dir.join(k.to_s)]
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

  def mutable_attributes
    [
      :working_dir,
      :source_files,
      :package_basedir,
      :package_name,
      :package_labels
    ]
  end

  def mutable_attribute?(attr)
    attr = attr.to_s.gsub(/=$?/, '').to_sym

    mutable_attributes.include?(attr)
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
  def mute_attributes!(attributes)
    attributes.each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }
    end

    self
  end
end
