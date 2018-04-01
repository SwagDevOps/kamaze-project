# frozen_string_literal: true

require_relative '../tools'
require_relative 'packager'

# Module providng several tools based on gemspec reader/writer
module SwagDev::Project::Tools::Gemspec
  class Reader
  end

  class Writer
  end

  # @abstract
  class Packager < SwagDev::Project::Tools::Packager
  end

  class Builder < Packager
  end

  class Packer < Packager
  end

  [:packager,
   :reader, :writer,
   :builder, :packer].each { |req| require_relative "gemspec/#{req}" }

  private_constant :Packager
end
