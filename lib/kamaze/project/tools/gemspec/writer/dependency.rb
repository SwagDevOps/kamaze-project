# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../writer'

# Describe dependency as an ``Hash`` indexed by type
#
# Sample of use:
#
# ```ruby
# selector = lambda do |type|
#   Bundler.environment.dependencies
#          .select { |d| d.groups.include?(type) }.to_a
# end
#
# dependency = Dependency.new({
#   runtime: selector.call(:default),
#   development: selector.call(:development),
# })
#
# puts dependency.keep(:runtime).to_s
# ```
class Kamaze::Project::Tools::Gemspec::Writer::Dependency
  # @param [Hash<Symbol, Gem::Dependency>] dependencies
  # @param [String] spec_name
  def initialize(dependencies, spec_name = 's')
    @dependencies = dependencies.to_h.freeze
    @spec_name = spec_name.to_s
    @keep = [:runtime, :development]
  end

  # @return [self]
  def keep(*keep)
    @keep = keep

    self
  end

  # Get dependencies hash representation.
  #
  # @return [Hash<Symbol, Gem::Dependency>]
  def to_h
    out = {}
    @dependencies.each do |type, gems|
      next unless @keep.include?(type)

      out[type] = Array.new(gems.clone)
    end

    out
  end

  # Get dependencies string representation.
  #
  # @return [String]
  def to_s
    lines = []

    self.to_h.each do |type, gems|
      gems.each do |gem|
        lines << make_spec_line(gem, type)
      end
    end

    lines.join("\n").rstrip
  end

  # Get dependencies array representation.
  #
  # @return [Array<Gem::Dependency>]
  def to_a
    out = []

    @dependencies.each do |type, gems|
      next unless @keep.include?(type)

      out.concat(gems)
    end

    out
  end

  protected

  attr_reader :spec_name

  # @param [Bundler::Dependency] gem
  # @param [String|Symbol] type
  # @return [String]
  def make_spec_line(gem, type)
    '%<spacer>s%<spec_name>s.%<method>s("%<gem>s", %<requirements>s)' % {
      spacer: "\s" * 2,
      spec_name: spec_name,
      method: "add_#{type}_dependency",
      gem: gem.name,
      requirements: gem.requirements_list
    }
  end
end
