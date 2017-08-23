# frozen_string_literal: true

require 'swag_dev/project/helper'

# Store last configured project
#
# @see SwagDev::Project
class SwagDev::Project::Helper::Project
  # @return [SwagDev::Project]
  attr_reader :memo

  # @return [SwagDev::Project]
  def setup(&block)
    @memo = SwagDev::Project.new(&block) if block
    @memo = SwagDev::Project.new if memo.nil? and block.nil?

    self.memo
  end

  # Forget stored state
  #
  # return [self]
  def forget
    @memo = nil

    self
  end
end
