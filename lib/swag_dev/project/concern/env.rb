# frozen_string_literal: true

require 'swag_dev/project/concern'
require 'active_support/concern'
require 'dotenv'
require 'pathname'

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
module SwagDev::Project::Concern::Env
  extend ActiveSupport::Concern

  # @!attribute [r] env_loaded
  #   @return [Hash] loaded environment

  included do
    class_eval <<-"ACCESSORS", __FILE__, __LINE__ + 1
        protected

        attr_writer :env_loaded
    ACCESSORS
  end

  # Loaded environment
  #
  # @return [Hash]
  def env_loaded
    @env_loaded ||= {}

    @env_loaded
  end

  protected

  # Load ``.env`` file (and store result)
  #
  # @todo load different (or additionnal) files depending on env/mode
  #
  # @return [self]
  def env_load(options = {})
    options[:pwd] = ::Pathname.new(options[:pwd] || Dir.pwd).realpath
    options[:file] ||= '.env'

    [options.fetch(:pwd).join(options.fetch(:file))].each do |file|
      env_loaded.merge!(::Dotenv.load(file))
    end

    self
  end
end
