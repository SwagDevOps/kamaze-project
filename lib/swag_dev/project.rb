# frozen_string_literal: true

require 'pathname'

module SwagDev
  class Project
    [
      'concern/env',
      'concern/helper',
      'concern/sham',
      'concern/tasks',
      'concern/gem',
      'concern/yardoc',
      'concern/versionable',
    ].each { |req| require "swag_dev/project/#{req}" }

    include Concern::Env
    include Concern::Helper
    include Concern::Sham
    include Concern::Tasks
    include Concern::Gem
    include Concern::Yardoc
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

  # Project subject, main class
  #
  # @return [Class]
  attr_reader :subject

  def initialize(&block)
    if block
      config = helper.get('project/config')

      yield(config)
      config.configure(self)
    end

    env_load(working_dir)

    self.name ||= ENV.fetch('PROJECT_NAME')
    self.working_dir ||= Dir.pwd
    self.subject ||= subject!
  end

  # @return [Hash]
  def version_info
    subject.version_info
  end

  # @return [Pathname]
  def path(*args)
    working_dir.join(*args)
  end

  # Load project
  #
  # @return [self]
  def load!
    tasks_load!
  end

  protected

  alias gem_name name

  def configure(&block)
    config = helper.get(:config)

    yield(config)
    config.configure(self)
  end

  # Set name
  def name=(name)
    @name = name.to_s.empty? ? nil : name.to_s.to_sym
  end

  # Set working dir
  def working_dir=(working_dir)
    @working_dir = Pathname.new(working_dir).realpath
  end

  # Set subject
  #
  # @param [Class] subject
  def subject=(subject)
    unless subject.is_a?(Class)
      # @todo raise error
    end

    @subject = subject
  end

  # Main class (subject of project)
  #
  # @return [Class]
  def subject!
    resolvable = name.to_s.gsub('-', '/')

    helper.get(:inflector).resolve(resolvable)
  end
end
