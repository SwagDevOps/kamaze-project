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

  # @param [SwagDev::Project::Tools::Gemspec::Builder::Filesystem] filesystem
  # @see fs
  def initialize(filesystem)
    @fs = filesystem
  end

  # Prepare packing
  #
  # @return [self]
  def prepare
    # fs.build_dirs.each_value { |dir| mkdir_p(dir) }
    # prepare_srcdir

    self
  end

  # Prepare ``src`` dir
  #
  # Source files are refreshed (deleted and copied again)
  #
  # @see [SwagDev::Project::Tools::Packer::Filesystem#packables]
  # @return [self]
  def prepare_srcdir
    return self

    packables = fs.packables.map(&:realpath)

    mkdir_p(fs.build_dirs[:src])
    Dir.chdir(fs.build_dirs[:src]) do
      rm_rf(Dir.glob('*'))

      packables.each { |path| cp_r(path, '.') }
    end

    self
  end
end
