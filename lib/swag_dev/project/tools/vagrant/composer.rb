# frozen_string_literal: true

require_relative '../vagrant'
require 'pathname'

# rubocop:disable Style/Documentation
class SwagDev::Project::Tools::Vagrant
  class Composer
  end
  require_relative 'composer/file'
end
# rubocop:enable Style/Documentation

# Compose ``boxes`` data structure from files
class SwagDev::Project::Tools::Vagrant::Composer
  # Path to files describing boxes
  #
  # defaults to ``./vagrant``
  #
  # @return [Pathname]
  attr_reader :path

  # Initialize from given path
  #
  # @param [String] path
  def initialize(path)
    @path = ::Pathname.new(path)
  end

  # Get boxes
  #
  # @return [Hash]
  def boxes
    results = {}
    files.each { |file| results[file.name] = file.load }

    results
  end

  # Get files used to generate ``boxes``
  #
  # @return [Array<Pathname>]
  def files
    Dir.glob("#{path}/*.yml")
       .delete_if { |file| /\.override.yml$/ =~ file }
       .map { |file| File.new(file) }
       .keep_if(&:loadable?)
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
