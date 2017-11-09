# frozen_string_literal: true

require 'pathname'
require 'fileutils'
require 'rake/file_utils'

require_relative '../filesystem'

# Utilities related to files/paths manipulations
module SwagDev::Project::Tools::Packager::Filesystem::Utils
  include FileUtils

  protected

  # Purge a directory
  #
  # @param [Pathname] dir
  # @return [Pathname]
  def purge(dir, options = {})
    options = { verbose: true }.merge(options)
    dir = ::Pathname.new(dir)

    if dir.exist?
      ls(dir).each do |entry|
        rm_rf(dir.join(entry), options)
      end
    end

    dir
  end

  # List entries
  #
  # @param [String] dir
  # @return [Array<Pathname>]
  def ls(dir)
    ::Pathname.new(dir).entries
              .map { |path| ::Pathname.new(path) }
              .delete_if { |path| ['.', '..'].include?(path.basename.to_s) }
  end

  # Extract directories from given paths
  #
  # @param [Array<String>] entries
  # @return [Array<Pathname>]
  def map_dirs(paths)
    paths.map { |path| ::Pathname.new(path) }
         .map(&:dirname)
         .delete_if { |path| ['.', '..'].include?(path.basename.to_s) }
         .uniq.sort
  end
end
