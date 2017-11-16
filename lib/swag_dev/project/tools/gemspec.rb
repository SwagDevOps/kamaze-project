# frozen_string_literal: true

require 'swag_dev/project/tools'
require 'swag_dev/project/tools/packager'

# Module providng several tools based on gemspec reader/writer
module SwagDev::Project::Tools::Gemspec
  class Builder < SwagDev::Project::Tools::Packager
  end

  require_relative 'gemspec/reader'
  require_relative 'gemspec/writer'
end
