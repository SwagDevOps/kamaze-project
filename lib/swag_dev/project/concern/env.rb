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

  protected

  # Load ``.env`` file (and store result)
  #
  # @todo load different (or additionnal) files depending on env/mode
  #
  # @return [self]
  def env_load(options = {})
    options[:pwd] = ::Pathname.new(options[:pwd] || Dir.pwd).realpath
    options[:filename] ||= '.env'

    @env_loaded ||= {}

    [options.fetch(:pwd).join(options.fetch(:filename))].each do |file|
      @env_loaded.merge(::Dotenv.load(file))
    end

    self
  end
end
