# frozen_string_literal: true

require 'swag_dev/project/concern'
require 'active_support/concern'
require 'dotenv'

# Load dotenv file
module SwagDev::Project::Concern::Env
  extend ActiveSupport::Concern

  # Load ``.env`` file (and store result)
  #
  # @return [self]
  def env_load(pwd = Dir.pwd)
    pwd = Pathname.new(pwd).realpath

    @env_loaded = Dotenv.load(pwd.join('.env'))

    self
  end
end
