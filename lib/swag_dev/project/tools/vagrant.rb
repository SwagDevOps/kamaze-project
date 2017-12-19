# frozen_string_literal: true

require 'swag_dev/project/tools'
require 'base64'
require 'pathname'
require 'cliver'

# Vagrant based,
# this class provides a easy and ready to use wrapper.
#
# Sample use in Rake task:
#
# ```ruby
# vagrant = project.tools.fetch(:vagrant)
# if vagrant.boxes? and vagrant.executable?
#    file vagrant.vagrantfile => vagrant.source_files do
#        vagrant.install
#    end
# end
# ```
#
# @see http://yaml.org/YAML_for_ruby.html
# @see https://friendsofvagrant.github.io/v1/docs/boxes.html
class SwagDev::Project::Tools::Vagrant
  # Path where resources are stored
  #
  # @return [Pathname]
  attr_reader :resources_dir

  # Working directory
  #
  # @return [Pathname]
  attr_writer :working_dir

  include FileUtils

  def initialize
    @resources_dir = Pathname.new(__dir__).join('..', 'resources').realpath

    yield self if block_given?

    @working_dir ||= Dir.pwd

    [:working_dir].each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }
    end
  end

  # Get working dir
  #
  # @return [Pathname]
  def working_dir
    Pathname.new(@working_dir).realpath
  end

  alias pwd working_dir

  # Absolute path to the vagrant executable
  #
  # @return [String|nil]
  def executable
    Cliver.detect(:vagrant)
  end

  # Denote ``vagrant`` executable is present
  #
  # @return [Boolean]
  def executable?
    !!executable
  end

  # Run the vagrant command +cmd+.
  #
  # @see https://github.com/ruby/rake/blob/master/lib/rake/file_utils.rb
  def execute(*cmd, &block)
    require 'rake/file_utils'

    Bundler.with_clean_env do
      cmd = [executable || 'vagrant'] + cmd

      sh(*cmd, &block)
    end
  end

  # Get path to actual ``Vagrantfile``
  #
  # @return [Pathname]
  def vagrantfile
    pwd.join('Vagrantfile')
  end

  # Get path to "templated" Vagrantfile
  #
  # @return [Pathname]
  def resource
    resources_dir.join('Vagrantfile')
  end

  # Install a new Vagrantfile
  #
  # Vagrant file is installed with additionnal YAML file,
  # defining ``boxes``
  #
  # @return [self]
  def install
    vagrantfile.write(vagrantfile_content)

    self
  end

  # Get files used to generate ``boxes``
  #
  # @return [Array<Pathname>]
  def box_files
    Dir.glob(pwd.join('vagrant/*.yml')).map do |file|
      Pathname.new(file)
    end
  end

  # Get files related to "box files"
  #
  # @return [Array<Pathname>]
  def source_files
    box_files.map do |file|
      Dir.glob("#{file.dirname}/**/**").map do |path|
        path = Pathname.new(path)

        path.file? ? path : nil
      end.compact
    end.flatten
  end

  # Get boxes configuration
  #
  # @return [Hash]
  def boxes
    results = {}
    box_files.each do |path|
      path = Pathname.new(path).realpath
      name = path.basename('.yml').to_s

      results[name] = YAML.load_file(path)
    end

    results
  end

  # Denote vagrant existence of configured boxes
  #
  # @return [Boolean]
  def boxes?
    !boxes.empty?
  end

  # Dump (boxes) config
  #
  # @return [String]
  def dump
    YAML.dump(boxes)
  end

  protected

  # Get generated content for ``Vagrantfile``
  #
  # @return [String]
  def vagrantfile_content
    boxes64 = Base64.strict_encode64(dump)

    ['# frozen_string_literal: true',
     '# vim: ai ts=2 sts=2 et sw=2 ft=ruby',
     nil,
     '[:base64, :yaml, :pp].each { |req| require req.to_s }',
     nil,
     "boxes = YAML.load(Base64.strict_decode64('#{boxes64}'))",
     nil,
     resource.read.gsub(/^#.*\n/, '')].map(&:to_s).join("\n")
  end
end
