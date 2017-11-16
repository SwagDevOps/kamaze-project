# frozen_string_literal: true

require 'pathname'
require_relative '../filesystem'
require_relative 'operator/utils'

# Filesystem operator (manipulator)
#
# This class is intended to manipulate a ``Filesystem``.
class SwagDev::Project::Tools::Packager::Filesystem::Operator
  include Utils

  # @return [SwagDev::Project::Tools::Packager::Filesystem]
  attr_reader :fs

  # @param [SwagDev::Project::Tools::Packager::Filesystem] filesystem
  # @param [Hash] options
  # @see fs
  def initialize(filesystem, options = {})
    @fs = filesystem
    @options = { verbose: true }.merge(options.to_h)

    # Pass included methods to protected
    utils_methods.each do |m|
      if self.public_methods.include?(m)
        self.singleton_class.class_eval { protected m }
      end
    end
  end

  # Prepare package
  #
  # @return [self]
  def prepare
    fs.package_dirs.each_value { |dir| mkdir_p(dir, options) }

    self.purge_purgeables.prepare_srcdir
  end

  # Purge purgeables elements
  #
  # @return [self]
  def purge_purgeables
    fs.purgeable_dirs.each_value { |dir| purge(dir, options) }

    self
  end

  # Prepare ``src`` dir
  #
  # Source files are refreshed (deleted and copied again)
  #
  # @return [self]
  def prepare_srcdir
    src_dir = ::Pathname.new(fs.package_dirs.fetch(:src))

    purge(src_dir, options)
    skel_dirs(src_dir, fs.source_files, options)

    fs.source_files.map do |path|
      origin = path.realpath # resolves symlinks

      cp(origin, src_dir.join(path), options.merge(preserve: true))
    end

    self
  end

  def verbose?
    options[:verbose] == true
  end

  protected

  # @return [Hash]
  attr_reader :options
end
