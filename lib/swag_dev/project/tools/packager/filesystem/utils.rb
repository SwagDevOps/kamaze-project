# frozen_string_literal: true

require 'pathname'
require_relative '../filesystem'

# Utilities related to files/paths manipulations
class SwagDev::Project::Tools::Packager::Filesystem::Utils
  # Extract directories from given paths
  #
  # @param [Array<String>] entries
  # @return [Array<Pathname>]
  def dirs(paths)
    paths.map { |path| ::Pathname.new(path) }
         .map(&:dirname)
         .delete_if { |path| ['.', '..'].include?(path.basename.to_s) }
         .uniq.sort
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
end
