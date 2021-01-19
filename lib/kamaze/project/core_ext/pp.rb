# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../../project'

Object.tap do |c|
  # @see https://ruby-doc.org/stdlib-2.4.0/libdoc/pp/rdoc/Kernel.html
  # @see https://github.com/topazproject/topaz/blob/bf4a56adbe03ae9ab4984729c733fcbc64a164c4/lib-ruby/pp.rb#L58
  # @see https://github.com/ruby/ruby/blob/a8dc5156e183489c5121fb1759bda5d9406d9175/lib/pp.rb#L602
  :pp.tap do |defined_method|
    c.define_method(defined_method) do |*objs|
      Kamaze::Project::Debug.new.yield_self do |printer|
        objs.each { |obj| printer.dump(obj) }

        objs.size <= 1 ? objs.first : objs
      end
    end

    [:private].each { |method_name| c.__send__(method_name, defined_method) }
  end
end
