# frozen_string_literal: true

require 'pathname'
require 'rubygems'
require_relative 'reader'
require_relative 'packer/command'

# Provides a ready to use interface based on rubyc (aka ruby-packer)
#
# @see https://github.com/pmq20/ruby-packer
class SwagDev::Project::Tools::Gemspec::Packer
  # @type [SwagDev::Project]
  attr_writer :project

  # @type [SwagDev::Project::Tools::Gemspec::Reader]
  attr_writer :gemspec_reader

  # Binary (executable) used to pack the project
  #
  # @see https://github.com/pmq20/ruby-packer
  attr_accessor :compiler

  # Get buildable (relative path)
  #
  # @return [Array<Pathname>]
  def packables
    specification.executables.map do |executable|
      path = package_dirs.fetch(:bin)
                         .join(executable)
                         .to_s.gsub(%r{^./}, '')

      ::Pathname.new(path)
    end
  end

  # Denote ready
  #
  # Test to detect if specification seems to be complete,
  # incomplete specification denotes a missing gemspec file
  #
  # @return [Boolean]
  def ready?
    gemspec_reader.read(Hash).include?(:full_name)
  end

  # Get host config, retrieved from ``RbConfig::CONFIG``
  #
  # @return [Hash]
  def config
    (RbConfig::CONFIG.map { |k, v| [k.to_sym, v] }).to_h
  end

  # Pack given packable
  #
  # @param [String] packable
  # @return [Pathname]
  def pack(packable)
    bin_dir = ::Pathname.new(specification.bin_dir)

    prepare
    command_for(packable).execute

    bin_dir.join(packable)
  end

  protected

  # @type [SwagDev::Project]
  attr_reader :project

  # @type [SwagDev::Project::Tools::Gemspec::Reader]
  attr_reader :gemspec_reader

  # Get package(d) files
  #
  # @return [Array<String>]
  def package_files
    (Dir.glob([
                '*.gemspec',
                'Gemfile', 'Gemfile.lock',
                'gems.rb', 'gems.locked',
              ]) + (gemspec_reader.read&.files).to_a).sort
  end

  def setup
    @project        ||= SwagDev.project
    @gemspec_reader ||= project.tools.fetch(:gemspec_reader)

    self.verbose        = false
    self.source_files   = package_files if self.source_files.to_a.empty?
    self.package_labels = [:src, :tmp, :bin]
    self.purgeables     = [:bin]
    self.package_name   = '%s/%s' % [
      config.fetch(:host_os),
      config.fetch(:host_cpu)
    ]

    [:project, :gemspec_reader, :compiler].each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }
    end
  end

  # Get command for (packing) a given packable
  #
  # @param [String] packable
  # @return [Command]
  def command_for(packable)
    bin_dir = ::Pathname.new(specification.bin_dir)

    Command.new do |command|
      command.executable = compiler
      command.pwd        = pwd
      command.src_dir    = package_dirs.fetch(:src)
      command.tmp_dir    = package_dirs.fetch(:tmp)
      command.bin_dir    = bin_dir
      command.packable   = packable
    end
  end

  # Get specification
  #
  # @return [Gem::Specification]
  def specification
    gemspec_reader.read
  end
end
