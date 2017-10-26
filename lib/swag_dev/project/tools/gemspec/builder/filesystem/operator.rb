# frozen_string_literal: true

require 'swag_dev/project/tools/gemspec/builder/filesystem'
require 'fileutils'
require 'rake/file_utils'

class SwagDev::Project::Tools::Gemspec::Builder
  class Filesystem
  end
end

# Filesystem operator (manipulator)
#
# This class is intended to manipulate a ``Filesystem``.
class SwagDev::Project::Tools::Gemspec::Builder::Filesystem::Operator
  include FileUtils

  # @return [SwagDev::Project::Tools::Gemspec::Builder::Filesystem]
  attr_reader :fs

  # #return [Hash]
  attr_reader :options

  # @param [SwagDev::Project::Tools::Gemspec::Builder::Filesystem] filesystem
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
  # @see [SwagDev::Project::Tools::Packer::Filesystem#packables]
  # @return [self]
  def prepare_srcdir
    src_dir = fs.build_dirs.fetch(:src)

    purge_srcdir

    fs.source_files.map { |path| path.dirname }
      .uniq
      .delete_if { |path| path.to_s == '.' }
      .sort
      .each { |dir| mkdir_p(src_dir.join(dir), options) }

    fs.source_files.map do |path|
      ln(path, src_dir.join(path), options.merge(force: true))
    end

    return self
  end

  def purge_srcdir
    src_dir = fs.build_dirs.fetch(:src)

    src_dir.children
           .map { |path| src_dir.realpath.join(path) }
           .each { |path| rm_rf(path, options) }
  end
end
