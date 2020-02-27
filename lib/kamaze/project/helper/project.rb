# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

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
