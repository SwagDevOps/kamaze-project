# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# Object is the default root of all Ruby objects
#
# Object inherits from BasicObject
# which allows creating alternate object hierarchies.
# Methods on Object are available to all classes
# (unless explicitly overridden).
#
# @see https://ruby-doc.org/core-2.5.0/Object.html
class Object
  autoload(:RbConfig, 'rbconfig')
  # noinspection RubyEmptyRescueBlockInspection
  begin
    autoload(:Gem, 'rubygems')
  rescue LoadError # rubocop:disable Lint/SuppressedException
  end

  RbConfig::CONFIG['ruby_version']&.tap do |ruby_version|
    if defined?(Gem) and Gem::Version.new(ruby_version) < Gem::Version.new('2.5.0')
      # Yields self to the block and returns the result of the block.
      #
      # @return [Object]
      # @see https://ruby-doc.org/core-2.5.0/Object.html#method-i-yield_self
      def yield_self
        yield(self)
      end
    end
  end
end
