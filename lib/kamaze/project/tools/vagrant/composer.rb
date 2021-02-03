# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../vagrant'
require 'pathname'
require 'yaml'

# rubocop:disable Style/Documentation

class Kamaze::Project::Tools::Vagrant
  class Composer
  end
  require_relative 'composer/file'
end

# rubocop:enable Style/Documentation

# Compose ``boxes`` data structure from files
class Kamaze::Project::Tools::Vagrant::Composer
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

  # Dump (boxes) config
  #
  # @return [String]
  def dump
    ::YAML.dump(boxes)
  end

  # Denote existence of configured boxes
  #
  # @return [Boolean]
  def boxes?
    !boxes.empty?
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
  # Files are indexed by ``name``.
  # Overrides and non-loablde files are excluded during listing.
  #
  # @return [Array<File>]
  def files
    Dir.glob("#{path}/*.yml")
       .delete_if { |file| /\.override.yml$/ =~ file }
       .map { |file| File.new(file) }
       .keep_if(&:loadable?)
       .freeze
  end

  # Get files related to "box files"
  #
  # Almost all files stored in ``path`` are considered as ``source``
  #
  # @return [Array<Pathname>]
  def sources
    Dir.glob("#{path}/**/**")
       .map { |path| ::Pathname.new(path) }
       .keep_if(&:file?)
       .sort_by(&:to_s).freeze
  end
end
