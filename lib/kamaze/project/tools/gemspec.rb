# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

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
