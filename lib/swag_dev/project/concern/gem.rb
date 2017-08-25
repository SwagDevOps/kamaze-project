# frozen_string_literal: true

require 'active_support/concern'

require 'swag_dev/project/concern'
require 'swag_dev/project/gem'

# Provides access to helpers
module SwagDev::Project::Concern::Gem
  extend ActiveSupport::Concern

  # Gem (based on ``gemspec`` file)
  #
  # @return [SwagDev::Project::Gem]
  def gem
    SwagDev::Project::Gem.new(gem_name, working_dir)
  end
end
