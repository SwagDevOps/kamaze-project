# frozen_string_literal: true

require 'swag_dev/project/tools'
require 'swag_dev/project/tools/packager'

# Module providng several tools based on gemspec reader/writer
module SwagDev::Project::Tools::Gemspec
  # @abstract
  class Packager < SwagDev::Project::Tools::Packager
  end

  class Builder < Packager
  end

  class Packer < Packager
  end

  private_constant :Packager

  [:reader, :writer,
   :builder, :packer].each { |req| require_relative "gemspec/#{req}" }
end
