# frozen_string_literal: true

require 'swag_dev/project/tools'
require 'base64'
require 'pathname'
require 'cliver'

# Vagrant based
#
# Sample use in Rake task:
#
# ```
# require 'project/vagrant_helper'
# vagrant = Project::VagrantHelper
#
# if vagrant.boxes? and helper.executable
#    file helper.installable => helper.installer do
#    helper.install
# end
# ```
class SwagDev::Project::Tools::VagrantHelper
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

  # Get boxes configuration
  #
  # @return [Hash]
  def boxes
    results = {}
    Dir.glob(pwd.join('vagrant/*.yml')).each do |path|
      path = Pathname.new(path).realpath
      box_name = path.basename('.*').to_s

      results[box_name] = YAML.load_file(path)
    end

    results
  end

  # Denote vagrant existence of configured boxes
  #
  # @return [Boolean]
  def boxes?
    !boxes.empty?
  end

  protected

  # Get generated content for ``Vagrantfile``
  #
  # @return [String]
  def vagrantfile_content
    boxes64 = Base64.strict_encode64(YAML.dump(boxes))

    ['# frozen_string_literal: true',
     '# vim: ai ts=2 sts=2 et sw=2 ft=ruby',
     nil,
     'require "base64"',
     'require "pp"',
     nil,
     "boxes = YAML.load(Base64.strict_decode64('#{boxes64}'))",
     nil,
     resource.read.gsub(/^#.*\n/, '')].map(&:to_s).join("\n")
  end
end
