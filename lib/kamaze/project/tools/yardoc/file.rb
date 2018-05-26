# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../yardoc'
require 'pathname'

# Describe a "file"
#
# as seen from ``YARD::CLI::Yardoc#files`` and
# ``YARD::CLI::YardocOptions#files``, as result a file can be evaluating
# as a glob expression, else file (``filepath``)  is a fixed string.
# Thus, file is castable to ``Array``.
class Kamaze::Project::Tools::Yardoc::File
  # @param [String] filepath
  # @param [Boolean] glob
  def initialize(filepath, glob = false)
    @glob = !!glob
    @filepath = filepath.to_s
  end

  # @return [Array<Pathname>]
  def paths
    proc do
      if glob?
        Dir.glob(filepath).map { |f| ::Pathname.new(f).dirname }
      else
        [::Pathname.new(filepath).dirname]
      end
    end.call.uniq.sort.map do |f|
      ::Pathname.new(f.to_s.gsub('./', ''))
    end
  end

  # Denote file MUST be evaluated as a glob expression
  #
  # @return [Boolean]
  def glob?
    @glob
  end

  def to_s
    filepath
  end

  alias to_a paths

  protected

  attr_reader :filepath
end
