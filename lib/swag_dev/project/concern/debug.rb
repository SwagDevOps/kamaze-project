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
#
# @see SwagDev::Project::Tools::Debug
module SwagDev::Project::Concern::Debug
  # @param [Array<Object>] args
  # @see SwagDev::Project::Tools::Debug
  def pp(*args)
    SwagDev::Project::Tools::Debug.new.dump(*args)
  end
end
