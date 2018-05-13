# frozen_string_literal: true

require_relative '../gemspec'
require 'pathname'
require 'gemspec_deps_gen'
require 'tenjin'

# Class intended to generate ``gemspec`` file from a template
#
# Default template filename is ``gemspec.tpl``.
# Consider to use ``Dir.chdir`` in order read and generate contents
# from the right directory (especially during tests).
#
# @see templated
# @see Kamaze::Project
class Kamaze::Project::Tools::Gemspec::Writer
  # Set path (almost filename) to templated gemspec
  #
  # @type [String|Pathname]
  attr_writer :templated

  # @see Kamaze.project
  # @type [Object|Kamaze::Project]
  # @return [Kamaze::Project]
  attr_accessor :project

  def mutable_attributes
    [:templated, :project]
  end

  # Get path (almost filename) to templated gemspec
  #
  # @return [Pathname]
  def templated
    Pathname.new(@templated)
  end

  # Get path (almost filename) to generated gemspec
  #
  # @return [Pathname]
  def generated
    Pathname.new("#{project.name}.gemspec")
  end

  # Get string representation
  #
  # @see generated
  # @return [String]
  def to_s
    generated.to_s
  end

  # Get variable used in template for ``Gem::Specification`` instantiation
  #
  # @return [String]
  def spec_id
    templated
      .read
      .scan(/Gem::Specification\.new\s+do\s+\|([a-z]+)\|/)
      .flatten.fetch(0)
  end

  # Get dependencies indexed by type.
  #
  # @return [Hash<Symbol, Gem::Dependency>]
  def dependencies
    dependencies = { runtime: [], development: [] }
    self.deps_gen.yield_self do |deps|
      { default: :runtime, development: :development }.each do |k, type|
        dependencies[type] = deps.bundler_gems(k).to_a.freeze
      end
    end

    dependencies.freeze
  end

  # Get template's context (variables)
  #
  # @return [Hahsh]
  def context
    require_relative 'writer/dependency'

    {
      name: project.name,
      dependencies: Dependency.new(dependencies, spec_id),
    }.yield_self do |variables|
      project.version_info.merge(variables)
    end
  end

  # Get generated/templated content
  #
  # @return [String]
  def content
    template.render(templated.to_s, context)
  end

  # Write gemspec file
  #
  # @return [self]
  def write
    generated.write(content)

    self
  end

  protected

  def setup
    @templated ||= 'gemspec.tpl'
    @project   ||= Kamaze.project
  end

  # Get ``GemspecDepsGen`` instance
  #
  # @see https://github.com/shvets/gemspec_deps_gen
  # @return [GemspecDepsGen]
  def deps_gen
    GemspecDepsGen.new
  end

  # Get template engine
  #
  # @return [Tenjin::Engine]
  def template
    Tenjin::Engine.new(cache: false)
  end
end
