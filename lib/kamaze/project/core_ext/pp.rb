# frozen_string_literal: true

require_relative '../tools/debug'

# rubocop:disable Style/Documentation

class Object
  private

  # Print arguments in pretty form
  #
  # @see https://ruby-doc.org/stdlib-2.4.0/libdoc/pp/rdoc/Kernel.html
  # @see https://github.com/topazproject/topaz/blob/master/lib-ruby/pp.rb
  def pp(*objs)
    debug = Kamaze::Project::Tools::Debug.new
    objs.each { |obj| debug.dump(obj) }

    objs.size <= 1 ? objs.first : objs
  end
end

# rubocop:enable Style/Documentation
