# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../debug'

# rubocop:disable Style/Documentation

class Object
  private

  # Print arguments in pretty form
  #
  # @see https://ruby-doc.org/stdlib-2.4.0/libdoc/pp/rdoc/Kernel.html
  # @see https://github.com/topazproject/topaz/blob/master/lib-ruby/pp.rb
  def pp(*objs)
    debug = Kamaze::Project::Debug.new
    objs.each { |obj| debug.dump(obj) }

    objs.size <= 1 ? objs.first : objs
  end
end

# rubocop:enable Style/Documentation
