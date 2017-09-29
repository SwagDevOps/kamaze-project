# frozen_string_literal: true

require 'swag_dev/project/tools'
require 'pathname'
require 'cliver'

# Provides a ready to use interface based on rubyc (aka ruby-packer)
#
# Only gem can be "packed", out-of-the box
# this behavior SHOULD be overriden using a ``sham``
class SwagDev::Project::Tools::Packer
  # Build dir (root directory)
  #
  # @return [Pathname]
  attr_accessor :build_dir

  # Working directory
  #
  # @return [Pathname]
  attr_accessor :working_dir

  # Path to pkg directory
  #
  # @return [String]
  attr_accessor :pkg_dir

  # Path to bin directory (as seen in gemspec)
  #
  # @return [String]
  attr_accessor :bin_dir

  # System config (retrieved from ``RbConfig::CONFIG``)
  #
  # @return [Hash]
  attr_reader :config

  # Executables (as seen in gemspec)
  #
  # @return [Array<String>]
  attr_accessor :executables

  include FileUtils

  def initialize
    @config = RbConfig::CONFIG

    yield self if block_given?

    @build_dir   ||= './build'
    @pkg_dir     ||= './pkg'
    @working_dir ||= Dir.pwd
    @bin_dir     ||= project.gem.spec.bindir # './bin'
    @executables ||= (project.gem.spec&.executables).to_a

    [:working_dir, :build_dir, :pkg_dir, :bin_dir, :executables].each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }
    end
  end

  # @return [SwagDev::Project]
  def project
    SwagDev.project
  end

  # Get path to packaged gem
  #
  # @return [Pathname]
  def pkg_dir
    pwd.join(@pkg_dir)
  end

  # Get (relative) path to bin dir
  #
  # @return [Pathname]
  def bin_dir
    Pathname.new(@bin_dir)
  end

  # Gem sources
  #
  # @return [Pathname]
  def gem_dir
    pkg_dir.join("#{project.name}-#{project.version_info[:version]}")
  end

  # Get build (absolute) path, root
  #
  # @return [Pathname]
  def build_dir
    pwd.join(@build_dir)
  end

  # @return [Array]
  def packables_globs
    [
      "#{pwd}/*.gemspec",
      "#{pwd}/Gemfile", "#{pwd}/Gemfile.lock",
      "#{pwd}/gems.rb", "#{pwd}/gems.locked",
      "#{gem_dir}/*"
    ]
  end

  # Items to be packed
  #
  # @return [Array<Pathname>]
  def packables
    Dir.glob(packables_globs)
       .sort
       .map { |path| Pathname.new(path) }
  end

  # Compiler (binary executable)
  #
  # @return [Pathname]
  def compiler
    Pathname.new(Cliver.detect!(:rubyc))
  end

  # Get working dir
  #
  # @return [Pathname]
  def working_dir
    Pathname.new(@working_dir).realpath
  end

  alias pwd working_dir

  # Get (absolute) paths for build dirs (as: src, tmp and bin)
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

  # Prepare packing
  #
  # @return [self]
  def prepare
    rm_rf(build_dirs[:src])

    build_dirs.each { |_k, dir| mkdir_p(dir) }

    packables.each do |path|
      cp_r(path, build_dirs[:src])
    end

    self
  end

  # Pack executables
  #
  # @return [Array<Pathname>]
  def pack
    prepare.build_executables
  end

  protected

  # Make command to pack a given executable
  #
  # @param [String] executable
  # @return [Array<String>]
  def make_command(executable)
    tmp_dir = pwd.join(build_dirs.fetch(:tmp))
    out_dir = pwd.join(build_dirs.fetch(:bin))

    [compiler,
     bin_dir.join(executable),
     '-r', '.',
     '-d', tmp_dir.to_s,
     '-o', out_dir.join(executable)].map(&:to_s)
  end

  # Build executables
  #
  # @return [Array<Pathname>]
  def build_executables
    results = []

    executables.to_a.each do |executable|
      Dir.chdir(pwd.join(build_dirs.fetch(:src))) do
        Bundler.with_clean_env do
          sh(*([ENV.to_h] + make_command(executable)))

          results << bin_dir.join(executable)
        end
      end
    end

    results
  end
end
