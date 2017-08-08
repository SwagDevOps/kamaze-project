# frozen_string_literal: true

require 'swag_dev/project'
require 'pathname'

# Describe a gem
#
# ``Gem`` has a ``working_dir``, default is ``Dir.pwd``
# and a ``name``, more informations are retrieved from
# ``spec_file`` (through ``Gem::Specification``).
class SwagDev::Project::Gem
  # @return [String\Symbol]
  attr_reader :name

  # @return [Pathname]
  attr_reader :working_dir

  # @param [String|Symbol|Object] gem_name
  # @param [String\Pathname] path
  def initialize(gem_name, working_dir = Dir.pwd)
    @name = gem_name
    @working_dir = Pathname.new(working_dir).realpath
  end

  # Gem specification
  #
  # @return [Gem::Specification]
  def spec
    Gem::Specification::load(spec_file)
  end

  # @return [Pathname]
  def package
    Pathname.new('pkg').join("#{spec.name}-#{spec.version}.gem")
  end

  # Get spec file path (should be absolute path)
  #
  # @return [Pathname]
  def spec_file
    working_dir.join("#{name}.gemspec")
  end

  # @return [String]
  def to_s
    package.to_s
  end
end
