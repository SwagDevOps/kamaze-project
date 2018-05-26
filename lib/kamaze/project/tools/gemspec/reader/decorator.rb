# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

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
    method = methods_mapping.fetch(type)
  rescue KeyError
    raise ArgumentError, "invalid type: #{type}"
  else
    self.__send__(method)
  end

  protected

  # @return [Gem::Specification]
  attr_reader :spec

  # Provides methods mapping
  #
  # @return [Hash]
  def methods_mapping
    {
      Hash => :decorate_to_hash,
      hash: :decorate_to_hash,
      OpenStruct => :decorate_to_ostruct,
      ostruct: :decorate_to_ostruct,
      open_struct: :decorate_to_ostruct,
    }
  end

  # Decorate to obtain a ``Hash``
  #
  # @return [Hash]
  def decorate_to_hash
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
