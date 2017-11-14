# frozen_string_literal: true

require 'pathname'
require 'cliver'
require 'fileutils'
require 'rake/file_utils'
require_relative '../builder'

# Command used to build a gem (from a gemspec file)
#
# Command is able to execute itself, it depends on
# ``FileUtils::sh`` provided by ``rake``.
# On execution, command ``chdir`` to ``src_dir``.
class SwagDev::Project::Tools::Gemspec::Builder::Command
  include FileUtils

  # Executable used by command
  attr_writer :executable

  # Filepath to the product issued by command
  attr_accessor :buildable

  # The path to source files
  attr_accessor :src_dir

  # Specification
  attr_accessor :specification

  # Original path where main program is executed
  attr_writer :pwd

  class InitializationError < RuntimeError
  end

  def initialize
    @pwd ||= Dir.pwd
    @executable ||= :gem

    yield self

    [:specification, :executable, :buildable, :pwd, :src_dir]
      .each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }

      if self.__send__(m).nil?
        raise InitializationError, "#{m} must be set, got nil"
      end
    end
  end

  # @return [Pathname]
  def pwd
    Pathname.new(@pwd)
  end

  # Get executable (binary executable)
  #
  # @return [Pathname]
  def executable
    Pathname.new(Cliver.detect!(@executable))
  end

  # Get path to build dir
  #
  # @return [Pathname]
  def gem_dir
    Pathname.new(buildable).dirname
  end

  # @return [Array<String>]
  def to_a
    [executable,
     :build,
     '--norc',
     pwd.join(src_dir, spec_file)].map(&:to_s)
  end

  def execute
    Dir.chdir(pwd.join(gem_dir)) do
      Bundler.with_clean_env { sh(*(self.to_a)) }
    end
  end

  protected

  # Get spec_file (from specification)
  #
  # @note ``spec_file`` MUST NOT include version number
  #
  # @return [String]
  def spec_file
    pattern = '%s.gemspec'

    pattern % Pathname.new(specification.spec_file)
                      .basename('.*')
                      .to_s
                      .gsub(/-([0-9 \.])+/, '')
  end
end
