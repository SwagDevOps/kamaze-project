# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../tools'

# Provides a packager
#
# Packager is intended to provide basic packaging operations
# @abstract
class Kamaze::Project::Tools::Packager < Kamaze::Project::Tools::BaseTool
  # @formatter:off
  {
    FileSystem: 'filesystem',
  }.each { |k, v| autoload(k, "#{__dir__}/packager/#{v}") }
  # @formatter:on

  require_relative 'packager/filesystem'
  require_relative 'packager/filesystem/operator'
  require_relative 'packager/filesystem/operator/utils'

  # Get filesystem
  #
  # @return [Kamaze::Project::Tools::Packager::Filesystem]
  attr_reader :fs

  def initialize
    @initialized = false
    # fs mutable attributes are accessibles during initialization
    # @see method_missing
    @fs = Filesystem.new

    yield self if block_given?

    super

    @initialized = true
  end

  # Denote class is initialized
  #
  # @return [Boolean]
  def initialized?
    @initialized
  end

  def method_missing(method, *args, &block)
    if respond_to_missing?(method)
      unless initialized?
        mutable = fs.mutable_attribute?(method)

        return fs.__send__(method, *args, &block) if mutable
      end

      return fs.public_send(method, *args, &block)
    end

    super
  end

  def respond_to_missing?(method, include_private = false)
    if method.to_s[-1] == '='
      unless initialized?
        return true if fs.mutable_attribute?(method)
      end
    end

    return true if fs.respond_to?(method, include_private)

    super(method, include_private)
  end
end
