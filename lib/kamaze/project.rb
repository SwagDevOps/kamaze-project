# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

module Kamaze
  class Project
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
  require 'tmpdir'

  {
    # @formatter:off
    YAML: 'yaml',
    Bootsnap: 'bootsnap',
    Pathname: 'pathname',
    # @formatter:on
  }.each { |s, fp| autoload(s, fp) }

  {
    # @formatter:off
    VERSION: 'version',
    BootsanpConfig: 'bootsnap_config',
    Bundled: 'bundled',
    Concern: 'concern',
    Config: 'config',
    Debug: 'debug',
    DSL: 'dsl',
    Helper: 'helper',
    Observable: 'observable',
    Observer: 'observer',
    Struct: 'struct',
    Tools: 'tools',
    ToolsProvider: 'tools_provider',
    # @formatter:on
  }.each { |s, fp| autoload(s, "#{__dir__}/project/#{fp}") }

  include(Bundled).tap do
    self.base_path = self.base_path.join('..')
    require 'bundler/setup' if bundled?
    require 'kamaze/project/core_ext/pp' if development?
    if development? and !YAML.safe_load(ENV['BOOTSNAP_DISABLE'].to_s)
      Bootsnap.setup(BootsanpConfig.new)
    end
  end

  ::Kamaze.instance_eval do
    class << self
      include Concern::Helper

      # Get an instance of project
      #
      # @return [Kamaze::Project]
      def project(&block)
        helper.get(:project).setup(&block)
      end
    end
  end

  # @see Kamaze::Project::Version
  # @return [Object]
  def version
    subject.const_get('VERSION')
  end

  include Concern::Mode
  include Concern::Helper
  include Concern::Tasks
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
