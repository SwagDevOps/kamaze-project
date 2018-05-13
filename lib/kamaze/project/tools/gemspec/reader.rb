# frozen_string_literal: true

require 'kamaze/project/tools/gemspec'
require 'kamaze/project/tools/gemspec/reader/decorator'
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

  attr_writer :working_dir

  def initialize
    @working_dir = Dir.pwd

    yield self if block_given?

    @gem_name ||= project.name

    [:project, :gem_name, :working_dir].each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }
    end
  end

  # Read gemspec
  #
  # @param [nil|Class|Symbol] as
  # @return [Gem::Specification|Object]
  def read(as = nil)
    spec = nil
    Dir.chdir(working_dir) do
      spec = Gem::Specification.load(self.spec_file.to_s)
    end

    as ? Decorator.new(spec).to(as) : spec
  end

  # Get spec file path (SHOULD be absolute path)
  #
  # @return [Pathname]
  def spec_file
    working_dir.join("#{project.name}.gemspec")
  end

  # Get project
  #
  # @see Kamaze.project
  # @return [Object|Kamaze::Project]
  def project
    @project || Kamaze.project
  end

  def working_dir
    Pathname.new(@working_dir).realpath
  end
end
