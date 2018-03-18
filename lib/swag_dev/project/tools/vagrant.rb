# frozen_string_literal: true

require_relative '../tools'
require_relative 'base_tool'
require 'base64'
require 'pathname'

# rubocop:disable Style/Documentation
class SwagDev::Project::Tools
  class Vagrant < BaseTool
  end

  [:composer, :shell, :writer, :remote].each do |req|
    require_relative "vagrant/#{req}"
  end
end
# rubocop:enable Style/Documentation

# Vagrant based,
# this class provides a easy and ready to use wrapper around ``vagrant``
# executable. VM configuration is easyfied by the use of YAML files.
#
# VM configurations are stored in a single directory (default: ``vagrant``)
# and can be overriden by an ``.override.yml`` file.
# A ``Vagrantfile`` is generated upon configurations.
#
# Sample use in Rake task:
#
# ```ruby
# vagrant = project.tools.fetch(:vagrant)
#
# if vagrant.boxes? and vagrant.executable?
#    file vagrant.vagrantfile => vagrant.sources do
#        vagrant.install
#    end
# end
# ```
#
# This class is almost a facade based on:
#
# * Composer
# * Writer
# * Shell
# * Remote
#
# @see http://yaml.org/YAML_for_ruby.html
# @see https://friendsofvagrant.github.io/v1/docs/boxes.html
class SwagDev::Project::Tools::Vagrant
  # Template file (used for code generation)
  #
  # @return [String]
  attr_accessor :template

  # Absolute path to the vagrant executable
  #
  # @return [String|nil]
  attr_accessor :executable

  # Get path to actual ``Vagrantfile``
  #
  # @return [Pathname]
  attr_accessor :vagrantfile

  # Path to files describing boxes (directory)
  #
  # defaults to ``./vagrant``
  #
  # @return [String]
  attr_accessor :path

  def mutable_attributes
    [:path, :executable, :template, :vagrantfile]
  end

  # Get working dir
  #
  # @return [Pathname]
  def pwd
    Pathname.new(Dir.pwd).realpath
  end

  # Denote ``vagrant`` executable is present
  #
  # @return [Boolean]
  def executable?
    shell.executable?
  end

  # Run the vagrant command with given ``args``.
  #
  # @see https://github.com/ruby/rake/blob/master/lib/rake/file_utils.rb
  def execute(*args, &block)
    shell.execute(*args, &block)
  end

  # Run a command remotely on box identified by ``box_id``
  #
  # Sample of use:
  #
  # ```ruby
  # vagrant.ssh('freebsd', 'rake clobber')
  # ```
  def ssh(*args, &block)
    remote.execute(*args, &block)
  end

  # Install a new Vagrantfile
  #
  # Vagrant file is installed with additionnal YAML file,
  # defining ``boxes``
  #
  # @return [self]
  def install
    writer.write(boxes)

    self
  end

  def method_missing(method, *args, &block)
    if respond_to_missing?(method)
      composer.public_send(method, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(method, include_private = false)
    return true if composer.respond_to?(method, include_private)

    super
  end

  protected

  # Get composer, responsible to read and combine files describing boxes
  #
  # @return [Composer]
  attr_reader :composer

  # Get a shell, to execute ``vagrant`` commands
  #
  # @return [Shell]
  attr_reader :shell

  # Get writer, reponsible of ``Vagrantfile`` generation
  #
  # @return [Writer]
  attr_reader :writer

  def setup
    @template ||= Pathname.new(__dir__).join('..', 'resources').to_s
    @vagrantfile ||= ::Pathname.new(@vagrantfile || pwd.join('Vagrantfile'))
    @executable ||= :vagrant
    @path ||= pwd.join('vagrant').to_s

    setup_compose
  end

  # Initialize most of the tools used internally
  def setup_compose
    @composer = Composer.new(@path)
    @shell = Shell.new(executable: executable)
    @writer = Writer.new(@template, vagrantfile)

    self
  end

  # Get remote shell provider
  #
  # @return [Remote]
  def remote
    Remote.new(boxes, executable: executable)
  end
end
