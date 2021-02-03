# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../status'

# Initialized using an Array representation of status
#
# A memento is kept.
# Given files are filtered by type.
#
# @abstract
class Kamaze::Project::Tools::Git::Status::FilesArray < Array
  class << self
    # Get type
    #
    # @return [Symbol]
    attr_reader :type
  end

  # Initialize using given status array representation
  #
  # @param [Array] status
  def initialize(status)
    super status.clone
                .keep_if { |file| file.public_send("#{self.class.type}?") }

    @memento = status.clone.map(&:freeze).freeze
  end

  protected

  # @return [Array]
  attr_reader :memento
end
