# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../yardoc'

# Provide watch related methods
#
# Yardoc (wrapper class) is used by a Watcher using tools
# it MUST provide some methods used to:
#
# * initialize ``Listen``
# * provide patterns (glob pattern matching)
#
# Instance of ``YARD::CLI::Yardoc`` is retrieved through ``core`` method
module Kamaze::Project::Tools::Yardoc::Watchable
  class File < Kamaze::Project::Tools::Yardoc::File
  end

  private_constant :File

  # Get paths
  #
  # @return [Array<Pathname>]
  def paths
    files.map do |file|
      file.to_a.min
    end.flatten.compact.uniq.sort
  end

  # Get patterns (usable for glob pattern matching)
  #
  # @return [Array<String>]
  def patterns
    files.map(&:to_s)
  end

  # Get files
  #
  # Mostly patterns,
  # addition of ``files`` with ``options.files``
  # SHOULD include ``README`` file, when ``.yardopts`` defined
  #
  # @return [Array<Kamaze::Project::Tools::Yardoc::File>]
  def files
    # @formatter:off
    [
      core.files.to_a.flatten.map { |f| File.new(f, true) },
      core.options.files.to_a.map { |f| File.new(f.filename, false) }
    ].flatten
    # @formatter:on
  end

  # Ignores files matching path match (regexp)
  #
  # @return [Array<String>]
  def excluded
    core.excluded
  end
end
