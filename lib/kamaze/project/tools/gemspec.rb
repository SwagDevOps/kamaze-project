# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../tools'

# Module providng several tools based on gemspec reader/writer
module Kamaze::Project::Tools::Gemspec
  # @formatter:off
  {
    Reader: 'reader',
    Writer: 'writer',
    Packager: 'packager',
    Builder: 'builder',
    Concern: 'concern',
    Packer: 'packer',
  }.each { |s, fp| autoload(s, "#{__dir__}/gemspec/#{fp}") }
  # @formatter:on
end
