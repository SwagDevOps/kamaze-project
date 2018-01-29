# frozen_string_literal: true

require_relative '../status'
require 'pathname'

# Status file
class SwagDev::Project::Tools::Git::Status::File
  # @return [Pathname]
  attr_reader :base

  # @return [Pathname]
  attr_reader :path

  # @return [String]
  attr_reader :flag

  # @param [Pathname|String] path
  # @param [String] flag
  # @param [Pathname|String] base
  def initialize(path, flag, base = Dir.pwd)
    @base = ::Pathname.new(base)
    @path = ::Pathname.new(path)
    @flag = flag.split('').freeze
  end

  def deleted?
    flag.include?('D')
  end

  def staged?
    !['?', '!', ' '].include?(flag[0])
  end

  def to_s
    absolute_path.to_s
  end

  # Get absolute path
  #
  # @return [Pathname]
  def absolute_path
    base.join(path)
  end
end
