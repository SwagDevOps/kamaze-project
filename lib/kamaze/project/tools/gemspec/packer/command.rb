# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require 'pathname'
require 'cliver'

require_relative '../packer'
require_relative '../../../concern/sh'
require_relative '../../../concern/cli/with_exit_on_failure'

# Build/pack a buildable
#
# Command is able to execute itself.
# Command depends on ``FileUtils::sh`` provided by ``rake``.
#
# During execution, command ``chdir`` to ``src_dir``.
class Kamaze::Project::Tools::Gemspec::Packer::Command
  include Kamaze::Project::Concern::Cli::WithExitOnFailure
  include Kamaze::Project::Concern::Sh

  # Executable used by command
  #
  # @type [String|Symbol]
  attr_writer :executable

  # Filepath to the product issued by command
  attr_accessor :packable

  # The directory for temporary files
  attr_accessor :tmp_dir

  # The directory where "compiled" executable stands
  #
  # @type [String]
  attr_writer :bin_dir

  # The path to source files
  attr_accessor :src_dir

  # @return [Pathname]
  attr_reader :pwd

  class InitializationError < RuntimeError
  end

  # @raise InitializationError
  def initialize
    yield self

    @executable ||= :rubyc
    @pwd = ::Pathname.new(Dir.pwd)

    [:executable, :packable, :tmp_dir, :bin_dir].each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }

      next unless self.__send__(m).nil?

      raise InitializationError, "#{m} must be set, got nil"
    end
  end

  # Executable used by command
  #
  # @return [Pathname]
  def executable
    ::Pathname.new(Cliver.detect!(@executable)).freeze
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
    packable = ::Pathname.new(self.packable)

    [executable,
     bin_dir.join(packable.basename),
     '-r', '.',
     '-d', pwd.join(tmp_dir),
     '-o', pwd.join(packable)].map(&:to_s)
  end

  def execute
    Dir.chdir(pwd.join(src_dir)) do
      with_exit_on_failure do
        # [DEPRECATED] `Bundler.with_clean_env` has been deprecated in favor of `Bundler.with_unbundled_env`.
        # If you instead want the environment before bundler was originally loaded, use `Bundler.with_original_env`
        Bundler.with_unbundled_env do
          sh(*self.to_a)

          self.retcode = self.shell_runner_last_status.exitstatus
        end
      end
    end
  end

  protected

  # Process attributes
  #
  # @raise InitializationError
  def process_attrs
    [:executable, :packable, :tmp_dir, :bin_dir].each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }

      if self.__send__(m).nil?
        raise InitializationError, "#{m} must be set, got nil"
      end
    end

    self
  end
end
