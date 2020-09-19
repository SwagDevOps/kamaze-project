# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../operator'

# Utilities related to files/paths manipulations
module Kamaze::Project::Tools::Packager::Filesystem::Operator::Utils
  autoload(:Pathname, 'pathname')

  lambda do
    require 'fileutils'
    require 'rake/file_utils'

    include FileUtils
  end.call

  protected

  # Purge a directory
  #
  # @param [Pathname] dir
  # @return [Pathname]
  def purge(dir, options = {})
    options = { verbose: true }.merge(options)
    dir = Pathname.new(dir)

    if dir.exist?
      ls(dir).each do |entry|
        rm_rf(dir.join(entry), **options)
      end
    end

    dir
  end

  # Make dirs from given basedir using entries (filepaths)
  #
  # @param [String|Pathname] basedir
  # @param [Array<>] entries
  # @param [Hash] options
  #
  # @return [Pathname]
  def skel_dirs(basedir, entries, options = {})
    Pathname.new(basedir).tap do
      map_dirs(entries).each { |dir| mkdir_p(basedir.join(dir), **options) }
    end
  end

  # List entries
  #
  # @param [String] dir
  # @return [Array<Pathname>]
  def ls(dir)
    # @formatter:off
    Pathname.new(dir).entries
            .map { |path| ::Pathname.new(path) }
            .delete_if { |path| ['.', '..'].include?(path.basename.to_s) }
    # @formatter:on
  end

  # Extract directories from given paths
  #
  # @param [Array<String>] paths
  # @return [Array<Pathname>]
  def map_dirs(paths)
    # @formatter:off
    paths.map { |path| ::Pathname.new(path) }
         .map(&:dirname)
         .delete_if { |path| ['.', '..'].include?(path.basename.to_s) }
         .uniq.sort
    # @formatter:on
  end

  # @return [Array<Symbol>]
  def utils_methods
    FileUtils.public_methods - self.public_methods
  end
end
