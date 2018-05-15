# frozen_string_literal: true

require 'fileutils'
require 'rubygems'
require 'rubygems/gem_runner'

require_relative 'packager'

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
class Kamaze::Project::Tools::Gemspec::Builder
  # Build ``.gem`` file
  #
  # @return [self]
  def build
    prepare

    buildable_dir = self.buildable.dirname.realpath

    # dive into ``src`` file
    Dir.chdir(gemspec_srcfile.dirname) do
      Gem::GemRunner.new.run(build_args).yield_self do |file|
        FileUtils.mv(file, buildable_dir)

        buildable_dir.join(file)
      end
    end

    self
  end

  # Get buildable (relative path)
  #
  # @return [Pathname]
  def buildable
    full_name = gemspec_reader.read(Hash).fetch(:full_name)
    file_path = fs.package_dirs
                  .fetch(:gem)
                  .join("#{full_name}.gem")
                  .to_s
                  .gsub(%r{^\./}, '')

    ::Pathname.new(file_path)
  end

  def ready?
    gemspec_reader.read(Hash)[:full_name].nil? ? false : super
  end

  alias buildable? ready?

  # Get path do gemspec present in ``src`` dir
  #
  # @return [Pathname]
  def gemspec_srcfile
    (package_dirs.fetch(:src)
                 .realpath
                 .join(buildable.basename('.*')).to_s
                 .gsub(/-([0-9 \.])+$/, '') + '.gemspec').yield_self do |s|
      Pathname.new(s)
    end
  end

  protected

  def setup
    super

    self.package_labels = [:src, :gem]
    self.purgeables     = [:gem]
    self.package_name   = "ruby/gem-#{Gem::VERSION}"
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
