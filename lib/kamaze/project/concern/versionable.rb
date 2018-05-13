# frozen_string_literal: true

require_relative '../concern'

require 'pathname'
require 'version_info'

# Provides a standardized way to use ``VersionInfo``
module Kamaze::Project::Concern::Versionable
  class << self
    def included(base)
      base.extend(ClassMethods)

      base.version_info
    end
  end

  # Class methods
  module ClassMethods
    # @return [Hash]
    def version_info
      unless const_defined?(:VERSION)
        include VersionInfo

        # @todo deternmine format from extension?
        VersionInfo.file_format = :yaml
        self.VERSION.file_name = version_basedir.join('version_info.yml')
        self.VERSION.load
      end

      self.VERSION.to_h.merge(version: self.VERSION.to_s).freeze
    end

    protected

    # Extract basedir from ``caller``
    #
    # @raise [Errno::ENOENT]
    # @return [Pathname]
    def version_basedir
      basedir = caller.grep(/in `include'/)
                      .fetch(0)
                      .split(/\.rb:[0-9]+:in\s+/).fetch(0)

      Pathname.new(basedir).realpath
    end
  end
end
