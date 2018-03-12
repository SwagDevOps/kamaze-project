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

  # Get boxes
  #
  # @return [Hash]
  def boxes
    results = {}
    files.each do |path|
      path = ::Pathname.new(path).realpath
      name = path.basename('.yml').to_s

      results[name] = YAML.load_file(path)
    end

    results
  end

  # Get files used to generate ``boxes``
  #
  # @return [Array<Pathname>]
  def files
    Dir.glob("#{path}/*.yml").map { |file| ::Pathname.new(file) }
  end

  # Get files related to "box files"
  #
  # @return [Array<Pathname>]
  def sources
    files.map do |file|
      Dir.glob("#{file.dirname}/**/**").map do |path|
        path = ::Pathname.new(path)

        path.file? ? path : nil
      end.compact
    end.flatten
  end
end
