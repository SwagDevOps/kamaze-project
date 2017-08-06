# frozen_string_literal: true

unless Kernel.const_defined?('SwagDev')
  module SwagDev
  end
end

class SwagDev::Project
  require 'swag_dev/project/concern/versionable'

  include Concern::Versionable
end
