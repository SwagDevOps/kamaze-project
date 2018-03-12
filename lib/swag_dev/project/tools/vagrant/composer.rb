# frozen_string_literal: true

require_relative '../vagrant'
require 'pathname'

class SwagDev::Project::Tools::Vagrant
  class Composer
  end
end

# Compose ``boxes`` data structure from files
class SwagDev::Project::Tools::Vagrant::Composer
  # Path to files describing boxes
  #
  # defaults to ``./vagrant``
  #
  # @return [Pathname]
  attr_reader :path

  def initialize(path)
    @path = ::Pathname.new(path)
  end

  # Get files used to generate ``boxes``
  #
  # @return [Array<Pathname>]
  def files
    Dir.glob("#{path}/*.yml").map { |file| ::Pathname.new(file) }
  end
end
