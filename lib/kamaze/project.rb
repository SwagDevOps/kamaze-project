# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# Kamaze namesapace
module Kamaze
  class Project # rubocop:disable Style/Documentation
    # @formatter:off
    {
      YAML: 'yaml',
      Pathname: 'pathname',
      Autoload: "#{__dir__}/project/autoload"
    }.each { |s, fp| autoload(s, fp) }
    # @formatter:on

    Autoload.new.call("#{__dir__}/project")

    include(Bundled).tap do
      self.base_path = self.base_path.join('..')
      require 'bundler/setup' if bundled?
      require_relative './project/core_ext/pp' if development?
    end
  end

  class << self
    # Get an instance of project
    #
    # @deprecated
    # @return [Kamaze::Project]
    def project(&block)
      Project.instance(&block)
    end
  end
end

# Represent a project
#
# Sample of use:
#
# ```ruby
# Kamaze.project do |c|
#   c.subject     = Kamaze::Project
#   c.name        = :'kamaze-project'
#   c.tasks       = [ :doc, :gem ]
# end
# ```
class Kamaze::Project
  include Concern::Mode
  include Concern::Helper
  include Concern::Tasks
  include Concern::Tools

  class << self
    include Concern::Helper

    # Get an instance of project
    #
    # @return [Kamaze::Project]
    def instance(&block)
      helper.get(:project).setup(&block)
    end
  end

  # @see Kamaze::Project::Version
  # @return [Object]
  def version
    subject.const_get('VERSION')
  end

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
    Pathname.new(Dir.pwd)
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
