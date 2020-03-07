# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../gemspec'
require_relative 'concern/reading'

# Provide a specialized packager, for ``gemspec`` based projects
#
# A ``gemspec`` reader class is used,
# it can be retrieved through ``project`` tools.
# This dynamic behaviour is the default one, but a specific reader or
# a ``project`` can be defined during initialization.
#
# Gem ``specification`` (``Gem::Specification``) is retrieved through
# the gemspec reader. The gemspec reader
# can be dynamically retrieved through the project.
#
# @abstract
class Kamaze::Project::Tools::Gemspec::Packager
  include Kamaze::Project::Tools::Gemspec::Concern::Reading

  def mutable_attributes
    [:gemspec_reader]
  end

  # Denote ready
  #
  # Test to detect if specification seems to be complete,
  # incomplete specification denotes a missing gemspec file
  #
  # @return [Boolean]
  def ready?
    gemspec_reader.read(Hash).include?(:full_name)
  end

  protected

  # Get package(d) files
  #
  # @return [Array<String>]
  def package_files
    # @formatter: off
    (gemspec_reader.read&.files).to_a.yield_self do |files| # rubocop:disable Style/RedundantParentheses
      Dir.glob(%w[*.gemspec Gemfile Gemfile.lock gems.rb gems.locked])
         .concat(files)
    end.sort
    # @formatter: on
  end

  def setup
    @gemspec_reader ||= Kamaze::Project.instance.tools.fetch(:gemspec_reader)

    self.verbose = false
    self.source_files = package_files if self.source_files.to_a.empty?
  end

  # Get specification
  #
  # @return [Gem::Specification]
  def specification
    gemspec_reader.read
  end
end
