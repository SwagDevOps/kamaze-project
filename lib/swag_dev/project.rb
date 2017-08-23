# frozen_string_literal: true

require 'pathname'

module SwagDev
  class Project
    [
      'concern/env',
      'concern/helper',
      'concern/sham',
      'concern/tasks',
      'concern/versionable',
      'gem'
    ].each { |req| require "swag_dev/project/#{req}" }

    include Concern::Env
    include Concern::Helper
    include Concern::Sham
    include Concern::Tasks
    include Concern::Versionable
  end

  class << self
    include Project::Concern::Helper

    # Get an instance of project
    #
    # @return [SwagDev::Project]
    def project(&block)
      helper.get(:project).setup(&block)
    end
  end
end

class SwagDev::Project
  # @return [Pathname]
  attr_accessor :working_dir

  # Project name
  #
  # @return [Symbol]
  attr_reader :name

  # @return [Hash]
  attr_reader :version_info

  # Project gem
  #
  # @return [SwagDev::Project::Gem]
  attr_reader :gem

  # Get an instance of ``YARD::CLI::Yardoc`` based on current environment
  #
  # @return [YARD::CLI::Yardoc]
  attr_reader :yardoc

  # Project subject, main class
  #
  # @return [Class]
  attr_reader :subject

  def initialize(&block)
    yield(self) if block

    @working_dir = Pathname.new(@working_dir || Dir.pwd).realpath
    @working_dir.freeze

    env_load(working_dir)

    @name = ENV.fetch('PROJECT_NAME').to_sym
    @subject = subject!
    @version_info = ({ version: subject.VERSION.to_s }
                                       .merge(subject.version_info)).freeze
    @gem = Gem.new(@name, working_dir)
  end

  # @return [Pathname]
  def path(*args)
    working_dir.join(*args)
  end

  # Load project
  #
  # @return [self]
  def load!
    @yardoc ||= helper.get('yardoc').cli(working_dir)

    tasks_load!
  end

  protected

  # Main class (subject of project)
  #
  # @return [Class]
  def subject!
    name = self.name.to_s.gsub('-', '/')

    helper.get(:inflector).resolve(name)
  end
end
