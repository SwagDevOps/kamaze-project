# frozen_string_literal: true

require_relative '../tools'
require_relative 'base_tool'
require 'base64'
require 'pathname'
require 'cliver'

# rubocop:disable Style/Documentation
class SwagDev::Project::Tools
  class Vagrant < BaseTool
  end

  require_relative 'vagrant/composer'
end
# rubocop:enable Style/Documentation

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
  # Template file (used for code generation)
  #
  # @return [Pathname]
  attr_accessor :template_path

  # Absolute path to the vagrant executable
  #
  # @return [String|nil]
  attr_accessor :executable

  # Path to files describing boxes
  #
  # defaults to ``./vagrant``
  #
  # @return [String]
  attr_accessor :boxes_path

  def mutable_attributes
    [:template_path, :executable]
  end

  include FileUtils

  # Get working dir
  #
  # @return [Pathname]
  def working_dir
    Pathname.new(Dir.pwd).realpath
  end

  alias pwd working_dir

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
    composer.files
  end

  # Get files related to "box files"
  #
  # @return [Array<Pathname>]
  def source_files
    composer.sources
  end

  # Get boxes configuration
  #
  # @return [Hash]
  def boxes
    composer.boxes
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

  # Composer provides boxes
  #
  # @return [Composer]
  attr_reader :composer

  def setup
    resources_path = Pathname.new(__dir__).join('..', 'resources').realpath
    template_path = resources_path.join('Vagrantfile')

    @template_path = Pathname.new(@template_path || template_path).realpath
    @executable = Cliver.detect(@executable || :vagrant) || 'vagrant'
    @boxes_path ||= pwd.join('vagrant').to_s
    @composer = Composer.new(boxes_path)
  end

  # Get generated content for ``Vagrantfile``
  #
  # @return [String]
  def vagrantfile_content
    boxes64 = Base64.strict_encode64(dump).yield_self do |text|
      word_wrap(text, 70).map { |s| "\s\s'#{s}'\\" }.join("\n").chomp('\\')
    end

    ['# frozen_string_literal: true',
     '# vim: ai ts=2 sts=2 et sw=2 ft=ruby', nil,
     '[:base64, :yaml, :pp].each { |req| require req.to_s }', nil,
     "cnf64 = \\\n#{boxes64}", nil,
     'boxes = YAML.safe_load(Base64.strict_decode64(cnf64), [Symbol])', nil,
     template_path.read.gsub(/^#.*\n/, '')]
      .map(&:to_s).join("\n").gsub(/\n\n+/, "\n\n")
  end

  # Wrap text into small chunks
  #
  # @param [String] text
  # @param [Fixnum] width
  # @return [Array<String>]
  def word_wrap(text, width = 80)
    text.each_char.each_slice(width).to_a.map(&:join)
  end
end
