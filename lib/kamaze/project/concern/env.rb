# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../concern'

# Load dotenv file
#
# Storing configuration in the environment is one of the tenets of a
# twelve-factor app. Anything that is likely to change between
# deployment environments, such as resource handles for databases or
# credentials for external services should be extracted
# from the code into environment variables.
#
# @see https://github.com/bkeepers/dotenv
# @see http://12factor.net/config
module Kamaze::Project::Concern::Env
  autoload(:Dotenv, 'dotenv')
  autoload(:Pathanme, 'pathname')

  # @!attribute [r] env_loaded
  #   @return [Hash] loaded environment

  class << self
    def included(base)
      base.class_eval <<-"ACCESSORS", __FILE__, __LINE__ + 1
        protected

        attr_writer :env_loaded
      ACCESSORS
    end
  end

  # Loaded environment
  #
  # @return [Hash]
  def env_loaded
    @env_loaded ||= {}
  end

  protected

  # Load ``.env`` file (and store result)
  #
  # @return [self]
  def env_load(**options)
    options = {
      # @formatter:off
      pwd: Pathname.new(options[:pwd] || Dir.pwd).realpath,
      file: '.env',
      # @formatter:on
    }.merge(options)

    # @todo load different (or additionnal) files depending on env/mode
    [Pathname.new(options.fetch(:pwd)).join(options.fetch(:file))].each do |file|
      env_loaded.merge!(Dotenv.load(file))
    end

    self
  end
end
