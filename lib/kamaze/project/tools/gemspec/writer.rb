# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../gemspec'

# Class intended to generate ``gemspec`` file from a template
#
# Default template filename is ``gemspec.tpl``.
# Consider to use ``Dir.chdir`` in order read and generate contents
# from the right directory (especially during tests).
#
# @see templated
# @see Kamaze::Project
class Kamaze::Project::Tools::Gemspec::Writer
  autoload(:FileUtils, 'fileutils')
  autoload(:Pathname, 'pathname')
  autoload(:Tenjin, 'tenjin')
  autoload(:DepGen, "#{__dir__}/writer/dep_gen")

  # Set path (almost filename) to templated gemspec
  #
  # @type [String|Pathname]
  attr_writer :templated

  # @see Kamaze.project
  # @type [Object|Kamaze::Project]
  #
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
    # @formatter:off
    templated
      .read
      .scan(/Gem::Specification\.new\s+do\s+\|([a-z]+)\|/)
      .flatten.fetch(0)
    # @formatter:on
  end

  # Get dependency
  #
  # @return [Dependency]
  def dependency
    DepGen.new(spec_id).dependency
  end

  # Get template's context (variables)
  #
  # @return [Hahsh]
  def context
    # @formatter:off
    {
      name: project.name,
      version: project.version,
      dependencies: dependency,
    }.yield_self do |variables|
      project.version.to_h.merge(variables)
    end
    # @formatter:on
  end

  # Get generated/templated content
  #
  # @return [String]
  def content
    template.render(templated.to_s, context)
  end

  # Get status for current gemspec file.
  #
  # @return [Hash{Symbol => Object}]
  def status
    Pathname.new(self.to_s).yield_self do |file|
      # @formatter:off
      {
        mtime: -> { return File.mtime(file) if file.file? }.call,
        content: -> { return file.read if file.file? }.call
      }
      # @formatter:on
    end
  end

  # Write gemspec file
  #
  # @return [self]
  def write(preserve_mtime: false)
    self.tap do
      (preserve_mtime ? status : {}).tap do |meta|
        generated.write(content)

        if preserve_mtime
          if content == meta.fetch(:content, nil)
            fs.touch(self.to_s, mtime: meta.fetch(:mtime), nocreate: true)
          end
        end
      end
    end
  end

  protected

  # @return [FileUtils]
  attr_reader :fs

  def setup
    @templated ||= 'gemspec.tpl'
    @project ||= Kamaze::Project.instance
    @fs ||= FileUtils
  end

  # Get template engine
  #
  # @return [Tenjin::Engine]
  def template
    Tenjin::Engine.new(cache: false)
  end
end
