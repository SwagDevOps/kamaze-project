# frozen_string_literal: true

require 'rubygems'
require 'rubygems/gem_runner'

require_relative '../gemspec'
require_relative 'reader'

# Package a ``gem`` from its ``gemspec`` file
#
# The build command allows you to create a gem from a ruby gemspec.
#
# The best way to build a gem is to use a Rakefile and the Gem::PackageTask
# which ships with RubyGems.
#
# The gemspec can either be created by hand or
# extracted from an existing gem with gem spec:
#
# ```sh
# gem unpack my_gem-1.0.gem
# # Unpacked gem: '.../my_gem-1.0'
# gem spec my_gem-1.0.gem --ruby > my_gem-1.0/my_gem-1.0.gemspec
# cd my_gem-1.0
# # edit gem contents...
# gem build my_gem-1.0.gemspec
# ```
#
# Sample of use:
#
# ```ruby
# builder = SwagDev.project.tools.fetch(:gemspec_builder)
# builder.build
# ```
class SwagDev::Project::Tools::Gemspec::Builder
  # @type [SwagDev::Project]
  attr_writer :project

  # @type [SwagDev::Project::Tools::Gemspec::Reader]
  attr_writer :gemspec_reader

  # @return [self]
  def build
    prepare

    Dir.chdir(buildable.dirname) do
      Gem::GemRunner.new.run(build_args)
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

  def buildable?
    gemspec_reader.read(Hash).include?(:full_name)
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
    self.package_labels = [:src, :gem]
    self.purgeables     = [:gem]
    self.package_name   = "ruby/gem-#{Gem::VERSION}"

    [:project, :gemspec_reader].each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }
    end
  end

  # Get args used by ``gem`` command
  #
  # @return [Array<String>]
  def build_args
    Dir.chdir(pwd) do
      [
        :build,
        '--norc',
        '%s.gemspec' % package_dirs.fetch(:src).realpath
                                   .join(buildable.basename('.*')).to_s
                                   .gsub(/-([0-9 \.])+$/, '')
      ].map(&:to_s)
    end
  end

  # Get specification
  #
  # @return [Gem::Specification]
  def specification
    gemspec_reader.read
  end
end
