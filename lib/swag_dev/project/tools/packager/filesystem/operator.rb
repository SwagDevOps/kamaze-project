# frozen_string_literal: true

require 'swag_dev/project/tools/packager/filesystem'
require 'fileutils'
require 'rake/file_utils'

class SwagDev::Project::Tools::Packager
  class Filesystem
  end
end

# Filesystem operator (manipulator)
#
# This class is intended to manipulate a ``Filesystem``.
class SwagDev::Project::Tools::Packager::Filesystem::Operator
  include FileUtils

  # @return [SwagDev::Project::Tools::Packager::Filesystem]
  attr_reader :fs

  # #return [Hash]
  attr_reader :options

  # @param [SwagDev::Project::Tools::Packager::Filesystem] filesystem
  # @param [Hash] options
  # @see fs
  def initialize(filesystem, options = {})
    @fs = filesystem
    @options = { verbose: true }.merge(options.to_h)
  end

  # Prepare build
  #
  # @return [self]
  def prepare
    fs.build_dirs.each_value { |dir| mkdir_p(dir, options) }
    prepare_srcdir

    self
  end

  # Prepare ``src`` dir
  #
  # Source files are refreshed (deleted and copied again)
  #
  # @return [self]
  def prepare_srcdir
    src_dir = purge(fs.build_dirs.fetch(:src))

    tree_dirs(fs.source_files).each do |dir|
      mkdir_p(src_dir.join(dir), options)
    end

    fs.source_files.map do |path|
      origin = path.realpath # resolves symlinks

      cp(origin, src_dir.join(path), options.merge(preserve: true))
    end

    self
  end

  protected

  # Purge a directory
  #
  # @param [Pathname] dir
  # @return [Pathname]
  def purge(dir)
    dir = ::Pathname.new(dir)

    ls(dir).each { |entry| rm_rf(dir.join(entry)) } if dir.exist?

    dir
  end

  # utils ------------------------------------------------------------

  # Extract directories paths
  #
  # @param [Array<String>] entries
  # @return [Array<Pathname>]
  def tree_dirs(entries)
    entries
      .map { |path| ::Pathname.new(path) }
      .map(&:dirname)
      .delete_if { |path| ['.', '..'].include?(path.basename.to_s) }
      .uniq.sort
  end

  # List entries
  #
  # @param [String] dir
  # @return [Array<Pathname>]
  def ls(dir)
    ::Pathname.new(dir).entries
              .map { |path| ::Pathname.new(path) }
              .delete_if { |path| ['.', '..'].include?(path.basename.to_s) }
  end
end
