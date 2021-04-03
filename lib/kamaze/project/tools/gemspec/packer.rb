# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../gemspec'

# Provides a ready to use interface based on rubyc (aka ruby-packer)
#
# @see https://github.com/pmq20/ruby-packer
class Kamaze::Project::Tools::Gemspec::Packer < Kamaze::Project::Tools::Gemspec::Packager
  autoload(:Gem, 'rubygems')
  autoload(:Pathname, 'pathname')
  autoload(:Command, "#{__dir__}/packer/command")

  # Binary (executable) used to pack the project
  #
  # @see https://github.com/pmq20/ruby-packer
  attr_accessor :compiler

  # Get buildable (relative path)
  #
  # @return [Array<Pathname>]
  def packables
    specification.executables.map do |executable|
      package_dirs.fetch(:bin).join(executable).to_s.gsub(%r{^./}, '').yield_self do |path|
        ::Pathname.new(path)
      end
    end
  end

  # Get host config, retrieved from ``RbConfig::CONFIG``
  #
  # @return [Hash]
  def config
    RbConfig::CONFIG.to_h.transform_keys(&:to_sym)
  end

  # rubocop:disable Lint/UselessMethodDefinition

  # Prepare package
  #
  # @return [self]
  # @see Kamaze::Project::Tools::Packager::Filesystem::Operator#prepare
  def prepare
    super
  end

  # rubocop:enable Lint/UselessMethodDefinition

  # Pack given packable
  #
  # @param [String] packable
  # @return [self]
  def pack(packable)
    prepare.tap { command_for(packable).execute }
  end

  def mutable_attributes
    super + [:compiler]
  end

  protected

  def setup
    super.tap do
      self.package_labels = [:src, :tmp, :bin]
      self.purgeables = [:bin]
      self.package_name = '%<os>s/%<arch>s' % {
        os: config.fetch(:host_os),
        arch: config.fetch(:host_cpu)
      }
    end
  end

  # Get command for (packing) a given packable
  #
  # @param [String] packable
  # @return [Command]
  def command_for(packable)
    Dir.chdir(pwd) do
      Command.new do |command|
        command.executable = compiler
        command.src_dir = package_dirs.fetch(:src)
        command.tmp_dir = package_dirs.fetch(:tmp)
        command.bin_dir = Pathname.new(specification.bindir)
        command.packable = packable
      end
    end
  end
end
