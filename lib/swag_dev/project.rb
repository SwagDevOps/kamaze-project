# frozen_string_literal: true
require 'pathname'

# Base module (almost a namespace)
module SwagDev
  # rubocop:disable Style/Documentation
  class Project
    [
      :env, :mode, :helper, :sham,
      :tasks, :versionable, :tools
    ].each do |req|
      require "swag_dev/project/concern/#{req}"
    end
  end
  # rubocop:enable Style/Documentation

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
  include Concern::Env
  include Concern::Mode
  include Concern::Helper
  include Concern::Sham
  include Concern::Tasks
  include Concern::Versionable
  include Concern::Tools

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

    @working_dir = ::Pathname.new(@working_dir || Dir.pwd).realpath

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

  alias pwd working_dir

  # Set name
  def name=(name)
    @name = name.to_s.empty? ? nil : name.to_s.to_sym
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
    resolvable = name.to_s.tr('-', '/')

    helper.get(:inflector).resolve(resolvable)
  end
end
