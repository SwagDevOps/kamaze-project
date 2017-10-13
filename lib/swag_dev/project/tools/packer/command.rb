# frozen_string_literal: true

require 'swag_dev/project/tools/packer'
require 'pathname'
require 'cliver'
require 'fileutils'
require 'rake/file_utils'

class SwagDev::Project::Tools::Packer
end

# Command used to build a buildable
#
# Command is able to execute itself, it depends on
# ``FileUtils::sh`` provided by ``rake``.
# On execution, command ``chdir`` to ``src_dir``.
class SwagDev::Project::Tools::Packer::Command
  include FileUtils

  # Executable used by command
  attr_writer :executable

  # Filepath to the product issued by command
  attr_accessor :buildable

  # The directory for temporary files
  attr_accessor :tmp_dir

  # The directory where "compiled" executable stands
  attr_writer :bin_dir

  # The path to source files
  attr_accessor :src_dir

  # Original path where main program is executed
  attr_writer :pwd

  class InitializationError < RuntimeError
  end

  def initialize
    @pwd ||= Dir.pwd
    @executable ||= :rubyc

    yield self

    [:executable, :buildable, :pwd, :tmp_dir, :bin_dir].each do |m|
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

  # Get path to "compiled" input file
  #
  # SHOULD like to ``bin`` as seen in gemspec ``bindir``
  #
  # @return [Pathname]
  def bin_dir
    Pathname.new(@bin_dir)
  end

  # @return [Array<String>]
  def to_a
    buildable = Pathname.new(self.buildable)

    [executable,
     bin_dir.join(buildable.basename),
     '-r', '.',
     '-d', pwd.join(tmp_dir),
     '-o', pwd.join(buildable)].map(&:to_s)
  end

  def execute
    Dir.chdir(pwd.join(src_dir)) do
      Bundler.with_clean_env { sh(*([ENV.to_h] + self.to_a)) }
    end
  end
end
