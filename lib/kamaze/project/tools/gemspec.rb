# frozen_string_literal: true

require_relative '../tools'
require_relative 'packager'

# Module providng several tools based on gemspec reader/writer
module Kamaze::Project::Tools::Gemspec
  class Reader < Kamaze::Project::Tools::BaseTool
  end

  class Writer < Kamaze::Project::Tools::BaseTool
  end

  # @abstract
  class Packager < Kamaze::Project::Tools::Packager
  end

  class Builder < Packager
  end

  class Packer < Packager
  end

  [:packager,
   :reader, :writer,
   :builder, :packer].each { |req| require_relative "gemspec/#{req}" }
end
