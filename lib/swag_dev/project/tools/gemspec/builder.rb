# frozen_string_literal: true

require 'swag_dev/project/tools/gemspec'
require 'swag_dev/project/tools/gemspec/builder/filesystem'
require 'swag_dev/project/tools/gemspec/builder/command'
require 'rubygems'

# Package a ``gem`` from its ``gemspec`` file
#
# The build command allows you to create a gem from a ruby gemspec.
#
# The best way to build a gem is to use a Rakefile and the Gem::PackageTask
# which ships with RubyGems.
#
# The gemspec can either be created by hand or extracted from an existing gem
# with gem spec:
#
# ```sh
# gem unpack my_gem-1.0.gem
# # Unpacked gem: '.../my_gem-1.0'
# gem spec my_gem-1.0.gem --ruby > my_gem-1.0/my_gem-1.0.gemspec
# cd my_gem-1.0
# [edit gem contents]
# gem build my_gem-1.0.gemspec
# ```
class SwagDev::Project::Tools::Gemspec::Builder
  # @type [SwagDev::Project]
  attr_writer :project

  # @type [SwagDev::Project::Tools::Gemspec::Reader]
  attr_writer :gemspec_reader

  # Get filesystem
  #
  # @return [SwagDev::Project::Tools::Gemspec::Builder::Filesystem]
  attr_reader :fs

  def initialize
    @initialized = false

    yield self if block_given?

    @fs = Filesystem.new do |fs|
      fs.gemspec_reader = self.gemspec_reader
      fs.project = self.project
    end

    @initialized = true
    [:project, :gemspec_reader].each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }
    end
  end

  # Denote class is initialized
  #
  # @return [Boolean]
  def initialized?
    @initialized
  end

  def method_missing(method, *args, &block)
    if respond_to_missing?(method)
      fs.public_send(method, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(method, include_private = false)
    unless initialized? and method.to_s[-1] == '='
      return true if fs.respond_to?(method, include_private)
    end

    super(method, include_private)
  end

  # Get buildable (relative path)
  #
  # @return [Pathname]
  def buildable
    full_name = gemspec_reader.read(Hash).fetch(:full_name)
    file_path = fs.build_dirs
                  .fetch(:gem)
                  .join("#{full_name}.gem")
                  .to_s
                  .gsub(%r{^\./}, '')

    Pathname.new(file_path)
  end

  def build
    fs.prepare

    Command.new do |command|
      command.executable    = :gem
      command.pwd           = pwd
      command.src_dir       = build_dirs.fetch(:src)
      command.buildable     = buildable
      command.specification = gemspec_reader.read
    end.execute
  end

  protected

  # Get project
  #
  # @see SwagDev.project
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

  # Get specification
  #
  # @return [Gem::Specification]
  def specification
    project.tools(:gemspec_reader).read
  end
end
