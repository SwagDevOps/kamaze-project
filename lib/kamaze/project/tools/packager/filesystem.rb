# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../packager'

# Filesystem description used during packaging
#
# Filesystem has an Operator, which is intended to manipulate
# described files and directories.
# Package has a name, see ``package_name``,
# package name SHOULD be constitued with two (_path_) parts.
# Package dirs are labeled, as a default, only ``:src`` is provided.
# Labels are used to constitute the complete directory path
# (relative to ``pwd``).
class Kamaze::Project::Tools::Packager::Filesystem
  autoload(:Pathname, 'pathname')

  # @formatter:off
  {
    Operator: 'operator',
  }.each { |k, v| autoload(k, "#{__dir__}/filesystem/#{v}") }
  # @formatter:on

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

  # Labels for purgeables dirs (during prepare)
  #
  # @type [Array<Symbol>]
  attr_writer :purgeables

  # @type [Boolean]
  attr_writer :verbose

  def initialize
    @package_basedir = 'build'
    @package_name    = 'sample/package'

    @working_dir     = Dir.pwd
    @package_labels  = [:src]

    @verbose         = true
    @operator        = self.operator

    yield self if block_given?

    @source_files ||= []
    @purgeables   ||= []

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
    @package_labels.map do |k|
      [k, package_dir.join(k.to_s)]
    end.to_h
  end

  # Get purgeable (named) paths
  #
  # @return [Hash]
  def purgeable_dirs
    @purgeables.map do |k|
      [k, package_dirs[k]] if package_dirs[k]
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
      :verbose,
      :purgeables,
      :working_dir,
      :source_files,
      :package_basedir,
      :package_name,
      :package_labels
    ].sort
  end

  def mutable_attribute?(attr)
    attr = attr.to_s.gsub(/=$?/, '').to_sym

    mutable_attributes.include?(attr)
  end

  protected

  # @return [Boolean]
  attr_reader :verbose

  # Get operator
  #
  # @return [Kamaze::Project::Tools::Packager::Filesystem::Operator]
  def operator
    const_class = self.class.const_get(:Operator)

    const_class.new(self, verbose: verbose)
  end

  # Pass some attributes to protected
  #
  # @return [self]
  def mute_attributes!(attributes)
    attributes.each do |m|
      # rubocop:disable Style/AccessModifierDeclarations
      self.singleton_class.class_eval { protected "#{m}=" }
      # rubocop:enable Style/AccessModifierDeclarations
    end

    self
  end
end
