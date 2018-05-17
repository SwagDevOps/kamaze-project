# frozen_string_literal: true

require_relative '../writer'
require_relative 'dependency'
require 'bundler'

# Dependencies generator (using a kindo of decorator)
#
# Inspiration taken from ``GemspecDepsGen``
#
# @see https://github.com/shvets/gemspec_deps_gen
class Kamaze::Project::Tools::Gemspec::Writer::DepGen
  # @param [String] spec_name
  def initialize(spec_name = 's')
    @spec_name = spec_name.to_s
  end

  # Get dependencies indexed by group
  #
  # @return [Hash]
  def dependencies
    {}.yield_self do |dependencies|
      { default: :runtime, development: :development }.each do |k, type|
        dependencies[type] = gems_by_group(k).to_a.freeze
      end

      dependencies
    end.freeze
  end

  # Get an object describing dependency
  #
  # @return [Kamaze::Project::Tools::Gemspec::Writer::Dependency]
  def dependency
    decorator.new(dependencies, @spec_name)
  end

  protected

  # Get gems for given group
  #
  # @param [Symbol|String] group
  # @return [Array]
  def gems_by_group(group)
    Bundler.environment
           .dependencies
           .select { |d| d.groups.include?(group.to_sym) }
           .to_a
  end

  # @return [Kamaze::Project::Tools::Gemspec::Writer::Dependency]
  def decorator
    Kamaze::Project::Tools::Gemspec::Writer::Dependency
  end
end