# frozen_string_literal: true

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
class SwagDev::Project::Tools::Gemspec::Packer::Command
  include SwagDev::Project::Concern::Cli::WithExitOnFailure
  include SwagDev::Project::Concern::Sh

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
    env = preserved_env

    Dir.chdir(pwd.join(src_dir)) do
      with_exit_on_failure do
        Bundler.with_clean_env do
          sh(*[env].concat(self.to_a))

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

  # Get preserved env (from given env)
  #
  # @param [ENV|Hash] from
  # @return [Hash]
  #
  # @todo refactor
  def preserved_env(from = ENV)
    env = {}
    from = from.to_h

    ['CPPFLAGS'].each do |key|
      next unless from.key?(key)

      env[key] = from.fetch(key)
    end

    env
  end
end
