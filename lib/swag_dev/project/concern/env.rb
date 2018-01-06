# frozen_string_literal: true

require_relative '../concern'

require 'active_support/concern'
require 'dotenv'
require 'pathname'

module SwagDev::Project::Concern
  # @rubocop:disable Style/Documentation
  module Env
  end
  # @rubocop:enable Style/Documentation
end

# Load dotenv file
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
    options[:filename] ||= '.env'

    [options.fetch(:pwd).join(options.fetch(:filename))].each do |file|
      env_loaded.merge!(::Dotenv.load(file))
    end

    self
  end
end
