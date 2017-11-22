# frozen_string_literal: true

require 'pathname'
require 'cliver'
require 'fileutils'
require 'rake/file_utils'
require_relative '../packer'

# Build/pack a buildable
#
# Command is able to execute itself.
# Command depends on ``FileUtils::sh`` provided by ``rake``.
#
# During execution, command ``chdir`` to ``src_dir``.
class SwagDev::Project::Tools::Gemspec::Packer::Command
  include FileUtils

  # Executable used by command
  attr_accessor :executable

  # Filepath to the product issued by command
  attr_accessor :buildable

  # The directory for temporary files
  attr_accessor :tmp_dir

  # The directory where "compiled" executable stands
  attr_accessor :bin_dir

  # The path to source files
  attr_accessor :src_dir

  # Original path where main program is executed
  attr_accessor :pwd

  class InitializationError < RuntimeError
  end

  def initialize
    yield self

    @pwd ||= Dir.pwd
    @executable ||= :rubyc

    attributes_process

    @pwd = ::Pathname.new(@pwd)
    @executable = ::Pathname.new(Cliver.detect!(@executable))

    pp @pwd
  end

  # Get path to "compiled" input file
  #
  # SHOULD like to ``bin`` as seen in gemspec ``bindir``
  #
  # @return [Pathname]
  def bin_dir
    ::Pathname.new(@bin_dir)
  end

  # @return [Array<String>]
  def to_a
    buildable = ::Pathname.new(self.buildable)

    [executable,
     bin_dir.join(buildable.basename),
     '-r', '.',
     '-d', pwd.join(tmp_dir),
     '-o', pwd.join(buildable)].map(&:to_s)
  end

  def execute
    Dir.chdir(pwd.join(src_dir)) do
      Bundler.with_clean_env do
        sh(*([ENV.to_h] + self.to_a))
      end
    end
  end

  protected

  # Process attributes
  #
  # @raise InitializationError
  def attributes_process
    [:executable, :buildable, :pwd, :tmp_dir, :bin_dir].each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }

      if self.__send__(m).nil?
        raise InitializationError, "#{m} must be set, got nil"
      end
    end

    self
  end
end
