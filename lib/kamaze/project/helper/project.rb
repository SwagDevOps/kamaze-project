# frozen_string_literal: true

require 'kamaze/project/helper'

# Store last configured project
#
# @see Kamaze::Project
class Kamaze::Project::Helper::Project
  # @return [Kamaze::Project]
  attr_reader :memo

  # @return [Kamaze::Project]
  def setup(&block)
    @memo = Kamaze::Project.new(&block) if block
    @memo = Kamaze::Project.new if memo.nil? and block.nil?

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
