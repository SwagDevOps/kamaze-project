# frozen_string_literal: true

require 'swag_dev/project/tools/packer/filesystem'

class SwagDev::Project::Tools::Packer
  class Filesystem
  end
end

# Filesystem operator (manipulator)
class SwagDev::Project::Tools::Packer::Filesystem::Operator
  include FileUtils

  attr_reader :fs

  # @param [SwagDev::Project::Tools::Packer::Filesystem]
  def initialize(filesystem)
    @fs = filesystem
  end

  # Prepare packing
  #
  # @return [self]
  def prepare
    fs.build_dirs.each_value { |dir| mkdir_p(dir) }
    prepare_srcdir

    self
  end

  # @return [self]
  def prepare_srcdir
    packables = fs.packables.map(&:realpath)

    mkdir_p(fs.build_dirs[:src])
    Dir.chdir(fs.build_dirs[:src]) do
      rm_rf(Dir.glob('*'))

      packables.each { |path| cp_r(path, '.') }
    end

    self
  end
end
