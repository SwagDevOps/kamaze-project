# frozen_string_literal: true

require_relative '../concern'
require_relative '../tools/debug'

# Provide debug module method(s)
#
# Sample of use:
#
# ```ruby
# self.extend(SwagDev::Project::Concern::Debug)
#
# pp(ENV)
# ```
module SwagDev::Project::Concern::Debug
  # @param [Object] obj
  # @param [IO] out
  # @param [Fixnum] width
  #
  # @see SwagDev::Project::Tools::Debug
  def pp(obj, out = STDOUT, width = nil)
    debug = SwagDev::Project::Tools::Debug.new

    debug.dump(obj, out, width)
  end
end
