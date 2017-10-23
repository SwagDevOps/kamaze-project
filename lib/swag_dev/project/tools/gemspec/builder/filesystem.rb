# frozen_string_literal: true

require 'swag_dev/project/tools/gemspec/builder'
require 'swag_dev/project/tools/gemspec/builder/filesystem/operator'
require 'pathname'

class SwagDev::Project::Tools::Gemspec::Builder
end

# Filesystem description used during build
class SwagDev::Project::Tools::Gemspec::Builder::Filesystem
  # Build dir (root directory)
  attr_writer :build_dir

  # Working directory
  attr_writer :working_dir

  # @type [SwagDev::Project]
  attr_writer :project

  # @type [SwagDev::Project::Tools::Gemspec::Reader]
  attr_writer :gemspec_reader

  def initialize
    @build_dir   = './build'
    @working_dir = Dir.pwd

    yield self if block_given?

    @operator = Operator.new(self)

    [:project, :gemspec_reader, :build_dir, :working_dir].each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }
    end
  end

  # Get build dir (root directory)
  #
  # @return [Pathname]
  def build_dir
    Pathname.new(@build_dir)
  end

  # Get (named) paths for build dirs (as: src, tmp and bin)
  #
  # @return [Hash]
  def build_dirs
    host_dir = Pathname.new(build_dir)
                       .join('ruby', "gem-#{Gem::VERSION}")

    { src: nil, gem: nil }.map do |k, str|
      [k, host_dir.join(k.to_s)]
    end.to_h
  end

  # Get (original) working dir
  #
  # @return [Pathname]
  def working_dir
    Pathname.new(@working_dir)
  end

  alias pwd working_dir

  # Get gem name (versioned)
  #
  # @return [String]
  def gem_name
    path = gemspec_reader.read(:hash).fetch(:full_gem_path)

    Pathname.new(path).basename.to_s
  end

  # Get glob expressions used to list source files
  #
  # @return [Array]
  def source_globs
    [
      '*.gemspec',
      'Gemfile', 'Gemfile.lock',
      'gems.rb', 'gems.locked',
    ] + (gemspec_reader.read&.files)
  end

  # Get source files
  #
  # @return [Array<Pathname>]
  def source_files
    Dir.chdir(pwd) do
      Dir.glob(source_globs)
         .sort
         .map { |path| Pathname.new(path) }
    end
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

  # @return [SwagDev::Project::Tools::Gemspec::Builder::Filesystem::Operator]
  attr_reader :operator

  # Get project
  #
  # @return [Object|SwagDev::Project]
  def project
    @project || SwagDev.project
  end

  # Get reader
  #
  # @return [SwagDev::Project::Tools::Gemspec::Reader]
  def gemspec_reader
    @gemspec_reader || project.tools.fetch(:gemspec_reader)
  end
end
