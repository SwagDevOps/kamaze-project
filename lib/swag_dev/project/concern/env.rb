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

  # Load ``.env`` file (and store result)
  #
  # @return [self]
  def env_load(pwd = Dir.pwd)
    pwd = ::Pathname.new(pwd).realpath

    @env_loaded = ::Dotenv.load(pwd.join('.env'))

    self
  end
end
