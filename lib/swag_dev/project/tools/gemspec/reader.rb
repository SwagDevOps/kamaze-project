# frozen_string_literal: true

require 'swag_dev/project/tools/gemspec'
require 'pathname'

# Read gemspec file
#
# @see SwagDev::Project
class SwagDev::Project::Tools::Gemspec::Reader
  attr_accessor :gem_name

  attr_writer :project

  def initialize
    yield self if block_given?

    @gem_name ||= project.name

    [:project, :gem_name].each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }
    end
  end

  # Get project
  #
  # @see SwagDev.project
  # @return [Object|SwagDev::Project]
  def project
    @project || SwagDev.project
  end
end
