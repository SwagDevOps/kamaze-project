# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../gemspec'

# Package a ``gem`` from its own ``gemspec`` file
#
# The build command allows you to create a ``gem`` from a ruby ``gemspec``.
#
# The best way to build a gem is to use a Rakefile and the Gem::PackageTask
# which ships with RubyGems. But, you can also use this class ;).
#
# Sample of use:
#
# ```ruby
# builder = Kamaze.project.tools.fetch(:gemspec_builder)
# builder.build if builder.ready?
# ```
class Kamaze::Project::Tools::Gemspec::Builder < Kamaze::Project::Tools::Gemspec::Packager
  autoload(:FileUtils, 'fileutils')
  autoload(:Pathname, 'pathname')

  # Build ``.gem`` file
  #
  # @return [self]
  def build
    self.tap do
      prepare

      buildable_dir = self.buildable.dirname.realpath

      # dive into ``src`` file
      Dir.chdir(gemspec_srcfile.dirname) do
        self.gem_runner.run(build_args).yield_self do |file|
          FileUtils.mv(file, buildable_dir)

          buildable_dir.join(file)
        end
      end
    end
  end

  # Get buildable (relative path)
  #
  # @return [Pathname]
  def buildable
    return nil unless ready? # @todo raise an explicit exception

    gemspec_reader.read(Hash).fetch(:full_name).tap do |full_name|
      # @formatter:off
      return fs.package_dirs
               .fetch(:gem)
               .join("#{full_name}.gem")
               .to_s
               .gsub(%r{^\./}, '')
               .yield_self { |file_path| Pathname.new(file_path) }
      # @formatter:on
    end
  end

  def ready?
    gemspec_reader.read(Hash)[:full_name].nil? ? false : super
  end

  alias buildable? ready?

  # Get path do gemspec present in ``src`` dir
  #
  # @return [Pathname]
  def gemspec_srcfile
    # @formatter:off
    (package_dirs.fetch(:src)
         .realpath
         .join(buildable.basename('.*')).to_s
         .gsub(/-([0-9 \.])+$/, '') + '.gemspec')
      .yield_self { |s| Pathname.new(s) }
    # @formatter:on
  end

  protected

  def setup
    super

    self.package_labels = [:src, :gem]
    self.purgeables = [:gem]
    self.package_name = "ruby/gem-#{Gem::VERSION}"
  end

  # @return [Gem::GemRunner]
  def gem_runner
    require 'rubygems'
    require 'rubygems/gem_runner'

    Gem::GemRunner.new
  end

  # Get args used by ``gem`` command
  #
  # @return [Array<String>]
  def build_args
    Dir.chdir(pwd) do
      [:build, gemspec_srcfile, '--norc'].map(&:to_s)
    end
  end
end
