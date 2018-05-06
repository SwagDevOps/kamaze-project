# frozen_string_literal: true

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
class SwagDev::Project::Tools::Gemspec::Writer::Dependency
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

  # @return [Hash<Symbol, Gem::Dependency>]
  def to_h
    out = {}
    @dependencies.each do |type, gems|
      next unless @keep.include?(type)

      out[type] = Array.new(gems.clone)
    end

    out
  end

  # @return [String]
  def to_s
    lines = []

    to_h.each do |type, gems|
      gems.each do |gem|
        lines << [
          "  #{spec_name}.add_#{type}_dependency ",
          "\"#{gem.name}\", #{gem.requirements_list}"
        ].join('')
      end
    end

    lines.join("\n").rstrip
  end

  protected

  attr_reader :spec_name
end
