# frozen_string_literal: true

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
    (Dir.glob([
                '*.gemspec',
                'Gemfile', 'Gemfile.lock',
                'gems.rb', 'gems.locked',
              ]) + (gemspec_reader.read&.files).to_a).sort
  end

  def setup
    @gemspec_reader ||= Kamaze.project.tools.fetch(:gemspec_reader)

    self.verbose      = false
    self.source_files = package_files if self.source_files.to_a.empty?
  end

  # Get specification
  #
  # @return [Gem::Specification]
  def specification
    gemspec_reader.read
  end
end
