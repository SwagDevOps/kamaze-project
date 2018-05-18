# frozen_string_literal: true

require_relative '../gemspec'
require_relative 'reader/decorator'

require 'pathname'
require 'rubygems'

# Read ``gemspec`` file
#
# Retrieve ``Gem::Specification`` through ``read`` method.
#
# @see Kamaze::Project
class Kamaze::Project::Tools::Gemspec::Reader
  # @return [String]
  attr_accessor :gem_name

  attr_writer :project

  def initialize
    yield self if block_given?

    @gem_name ||= project.name

    [:project, :gem_name].each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }
    end
  end

  # @return [Pathname]
  def pwd
    ::Pathname.new(Dir.pwd)
  end

  # Read gemspec (as given ``type``)
  #
  # Return ``Gem::Specification`` or given ``type``
  #
  # @raise [ArgumentError] when type is not supported
  # @param [nil|Class|Symbol] as_type
  # @return [Gem::Specification|Object]
  def read(type = nil)
    Dir.chdir(pwd) do
      spec = Gem::Specification.load(self.spec_file.to_s)

      type ? Decorator.new(spec).to(type) : spec
    end
  end

  # Get (gem)spec file path
  #
  # @return [Pathname]
  def spec_file
    pwd.join("#{project.name}.gemspec")
  end

  # Get project
  #
  # @see Kamaze.project
  # @return [Object|Kamaze::Project]
  def project
    @project || Kamaze.project
  end
end
