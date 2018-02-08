# frozen_string_literal: true

require_relative '../status'

# Initialized using an Array representation of status
#
# A memento is kept.
# Given files are filtered by type.
#
# @abstract
class SwagDev::Project::Tools::Git::Status::FilesArray < Array
  class << self
    # Get type
    #
    # @return [Symbol]
    attr_reader :type
  end

  # @param [Array] a
  def initialize(a)
    unless self.class.type.nil?
      super a.clone
             .keep_if { |file| file.public_send("#{self.class.type}?") }
    end

    @memento = a.clone.map(&:freeze).freeze
  end

  protected

  # @return [Array]
  attr_reader :memento
end
