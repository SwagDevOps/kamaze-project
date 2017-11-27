# frozen_string_literal: true

require 'pathname'
require 'rubygems'
require_relative 'reader'
require_relative 'packer/command'

# Provides a ready to use interface based on rubyc (aka ruby-packer)
#
# @see https://github.com/pmq20/ruby-packer
class SwagDev::Project::Tools::Gemspec::Packer
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

  def mutable_attributes
    super + [:compiler]
  end

  protected

  def setup
    super

    self.package_labels = [:src, :tmp, :bin]
    self.purgeables     = [:bin]
    self.package_name   = '%s/%s' % [
      config.fetch(:host_os),
      config.fetch(:host_cpu)
    ]
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
end
