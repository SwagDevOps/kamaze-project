# frozen_string_literal: true

require_relative '../reader'
require_relative '../concern'

# Provides gemspec reader
#
# Base objects using a ``gemspec`` to obtain specification
#
# @see SwagDev::Project::Tools::Gemspec::Reader
module SwagDev::Project::Tools::Gemspec::Concern::Reading
  class << self
    def included(base)
      return if base.respond_to?(:'gemspec_reader=')

      base.class_eval <<-"ACCESSORS", __FILE__, __LINE__ + 1
        attr_writer :gemspec_reader
      ACCESSORS
    end
  end

  protected

  # @return [SwagDev::Project::Tools::Gemspec::Reader]
  def gemspec_reader
    @gemspec_reader ||= SwagDev.project.fetch(:gemspec_reader)

    @gemspec_reader
  end

  # Get specification
  #
  # @return [Gem::Specification]
  def specification
    specification = gemspec_reader.read

    specification.define_singleton_method(:'ready?') do
      gemspec_reader.read(Hash).include?(:full_name)
    end

    specification
  end
end
