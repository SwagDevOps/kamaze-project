# frozen_string_literal: true

require 'pathname'

# Base module (almost a namespace)
module SwagDev
  # rubocop:disable Style/Documentation

  class Project
    module Concern
      [nil, :env, :mode, :helper,
       :tasks, :versionable, :tools].each do |req|
        require_relative "project/concern/#{req}".gsub(%r{/$}, '')
      end
    end
  end

  # rubocop:enable Style/Documentation
end

# Base namespace
module SwagDev
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
# SwagDev.project do |c|
#   c.subject     = SwagDev::Project
#   c.name        = :'swag_dev-project'
#   c.tasks       = [ :doc, :gem ]
# end
# ```
class SwagDev::Project
  include Concern::Mode
  include Concern::Helper
  include Concern::Tasks
  include Concern::Versionable
  include Concern::Tools

  # Project name
  #
  # @return [Symbol]
  attr_reader :name

  # Project subject, main class
  #
  # @return [Class]
  attr_reader :subject

  class << self
    include Concern::Env

    # Load "env file" + ruby files from ``boot`` directory
    #
    # @return [self]
    def boot
      env_load

      Dir.glob("#{__dir__}/project/boot/*.rb").each do |bootable|
        require_relative bootable
      end

      self
    end
  end

  def initialize(&block)
    self.class.boot

    if block
      config = helper.get('project/config')
      yield(config)
      config.configure(self)
    end

    self.name ||= ENV.fetch('PROJECT_NAME')
    self.subject ||= subject!

    self.tools.freeze
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
    pwd.join(*args)
  end

  # Load project
  #
  # @return [self]
  def load!
    tasks_load!
  end

  # @return [Pathname]
  def pwd
    ::Pathname.new(Dir.pwd)
  end

  protected

  alias gem_name name

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
