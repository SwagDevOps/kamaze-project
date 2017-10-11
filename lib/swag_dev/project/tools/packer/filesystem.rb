# frozen_string_literal: true

require 'swag_dev/project/tools/packer'
require 'pathname'

class SwagDev::Project::Tools::Packer
end

# Represents filesystem used during compilation (or packing)
#
# Some basic/trivial operations are provided
class SwagDev::Project::Tools::Packer::Filesystem
  include FileUtils

  # Build dir (root directory)
  attr_writer :build_dir

  # Working directory
  attr_writer :working_dir

  # Path to bin directory (as seen in gemspec)
  attr_writer :bin_dir

  # Path to pkg directory
  #
  # @return [String]
  attr_writer :pkg_dir

  def initialize
    @build_dir   = './build'
    @working_dir = Dir.pwd
  end

  # Get host config, retrieved from ``RbConfig::CONFIG``
  #
  # @return [Hash]
  def config
    RbConfig::CONFIG
  end

  def build_dir
    Pathname.new(@build_dir)
  end

  # Get (named) paths for build dirs (as: src, tmp and bin)
  #
  # @return [Hash]
  def build_dirs
    host_dir = Pathname.new(build_dir)
                       .join(config.fetch('host_os'),
                             config.fetch('host_cpu'))

    { src: nil, tmp: nil, bin: nil }.map do |k, str|
      [k, host_dir.join(k.to_s)]
    end.to_h
  end

  def working_dir
    Pathname.new(@working_dir)
  end

  alias pwd working_dir

  def bin_dir
    @bin_dir ||= project.gem.spec.bindir

    Pathname.new(@bin_dir)
  end

  # Get executables (file names)
  #
  # @return [Array<String>]
  def executables
    @executables ||= (project.gem.spec&.executables).to_a

    @executables
  end

  # Get buildables (exepected results)
  #
  # @return [Pathname]
  def buildables
    executables.to_a.map do |executable|
      build_dirs.fetch(:bin).join(executable)
    end
  end

  # Get path to packaged gem
  #
  # @return [Pathname]
  def pkg_dir
    @pkg_dir ||= './pkg'

    Pathname.new(@pkg_dir)
  end

  # Gem sources
  #
  # @return [Pathname]
  def gem_dir
    pkg_dir.join("#{project.name}-#{project.version_info[:version]}")
  end

  # Get glob expressions used to list ``packables``
  #
  # @return [Array]
  def packables_globs
    [
      './*.gemspec',
      './Gemfile', './Gemfile.lock',
      './gems.rb', './gems.locked',
      "#{gem_dir}/*",
    ]
    # "#{gem_dir}/**/**", # must follow directory
  end

  # Items to be packed
  #
  # @return [Array<Pathname>]
  def packables
    Dir.chdir(pwd) do
      Dir.glob(packables_globs)
         .sort
         .map { |path| Pathname.new(path) }
    end
  end

  protected

  # @return [SwagDev::Project]
  def project
    SwagDev.project
  end
end
