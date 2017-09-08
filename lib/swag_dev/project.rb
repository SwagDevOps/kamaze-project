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
      'concern/tools',
    ].each { |req| require "swag_dev/project/#{req}" }

    include Concern::Env
    include Concern::Helper
    include Concern::Sham
    include Concern::Tasks
    include Concern::Gem
    include Concern::Yardoc
    include Concern::Versionable
    include Concern::Tools
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

# Represent a project
#
# Sample of use:
#
# ```ruby
# SwagDev::Project.new do do |c|
#   c.working_dir = Dir.pwd
#   c.subject     = SwagDev::Project
#   c.name        = :'swag_dev-project'
#   c.tasks       = [ :doc, :gem ]
# end
# ```
class SwagDev::Project
  # @return [Pathname]
  attr_accessor :working_dir

  # Project name
  #
  # @return [Symbol]
  attr_reader :name

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

    self.working_dir ||= Dir.pwd

    env_load(working_dir)

    self.name ||= ENV.fetch('PROJECT_NAME')
    self.subject ||= subject!
  end

  # Get subject version_info
  #
  # @return [Hash]
  def version_info
    const = subject.const_get(:VERSION)
    vinfo = const.respond_to?(:to_h) ? const.to_h : {}

    vinfo.merge(
      name: self.name,
      version: const.to_s
    ).freeze
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
