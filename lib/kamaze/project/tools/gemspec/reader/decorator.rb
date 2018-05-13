# frozen_string_literal: true

require 'kamaze/project/tools/gemspec/reader'
require 'ostruct'

class Kamaze::Project::Tools::Gemspec::Reader
end

# Decorator for ``Gem::Specification``
#
# @note Decorator is not recursive
class Kamaze::Project::Tools::Gemspec::Reader::Decorator
  # @param [Gem::Specification] spec
  def initialize(spec)
    @spec = spec
  end

  # Decorate specification to a given type
  #
  # @param [Class|symbol] type
  # @return [Object]
  #
  # @raise [ArgumentError]
  # @see methods
  def to(type)
    raise ArgumentError, "invalid type: #{type}" unless methods[type]

    self.__send__(methods.fetch(type))
  end

  protected

  # @return [Gem::Specification]
  attr_reader :spec

  # Provides methods mapping
  #
  # @return [Hash]
  def methods
    {
      Hash => :decorate_to_h,
      hash: :decorate_to_h,
      OpenStruct => :decorate_to_ostruct,
      ostruct: :decorate_to_ostruct,
      open_struct: :decorate_to_ostruct,
    }
  end

  # Decorate to obtain a ``Hash``
  #
  # @return [Hash]
  def decorate_to_h
    result = {}

    spec.instance_variables.each do |k|
      k = k.to_s.gsub(/^@/, '').to_sym

      result[k] = spec.__send__(k) if spec.respond_to?(k)
    end

    result
  end

  # Decorate to obtain an ``OpenStruct``
  #
  # @return [OpenStruct]
  def decorate_to_ostruct
    OpenStruct.new(decorate_to_h)
  end
end
