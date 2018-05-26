# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../project'
require_relative 'concern/observable'
# implicitely require observer
require_relative 'observer'

# Observable provides the methods for managing the associated observers.
#
# @abstract
# @see Kamaze::Project::Concern::Observable
class Kamaze::Project::Observable
  include Kamaze::Project::Concern::Observable
end
