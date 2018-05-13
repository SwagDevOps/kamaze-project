# frozen_string_literal: true

require 'kamaze/project'
require 'ostruct'

# Generic struct (ala`` OpenStruct``)
class Kamaze::Project::Struct < OpenStruct
  # Introduces some strictness on ``OpenStruct#method_missing``
  #
  # @raise [NoMethodError]
  # @see https://apidock.com/ruby/OpenStruct/method_missing
  # @return [Object]
  def method_missing(method, *args)
    if method[-1] != '='
      unless self.to_h.include?(method.to_sym)
        message = "undefined method `#{method}' for #{self}"

        raise NoMethodError, message, caller(1)
      end
    end

    super
  end

  def respond_to_missing?(method, include_private = false)
    super
  end
end
