# frozen_string_literal: true

require_relative '../gemspec'
require_relative 'reader'

class SwagDev::Project::Tools::Gemspec::Packager
  # @type [SwagDev::Project]
  attr_accessor :project

  # @type [SwagDev::Project::Tools::Gemspec::Reader]
  attr_accessor :gemspec_reader

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
    @project        ||= SwagDev.project
    @gemspec_reader ||= project.tools.fetch(:gemspec_reader)

    self.verbose      = false
    self.source_files = package_files if self.source_files.to_a.empty?
  end

  # Get specification
  #
  # @return [Gem::Specification]
  def specification
    gemspec_reader.read
  end

  def mutable_attributes
    [:gemspec_reader, :project]
  end
end
