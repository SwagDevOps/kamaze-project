# frozen_string_literal: true

require 'pathname'

module SwagDev
  class Project
    [
      'concern/helper',
      'concern/versionable',
      'gem'
    ].each { |req| require "swag_dev/project/#{req}" }
  end

  class << self
    include Project::Concern::Helper

    # Get a singleton instance of project
    #
    # @return [SwagDev::Project]
    def project
      helper.get(:project)
    end
  end
end

class SwagDev::Project
  include Concern::Versionable
  include Concern::Helper

  # Project name
  #
  # @return [Symbol]
  attr_reader :name

  # @return [Hash]
  attr_reader :version_info

  # Project gem
  #
  # @return [Pathname]
  attr_reader :gem

  # Project subject, main class
  #
  # @return [Class]
  attr_reader :subject

  def initialize
    @name = ENV.fetch('PROJECT_NAME').to_sym
    @subject = subject!
    @version_info = ({
                       version: subject.VERSION.to_s
                     }.merge(subject.version_info)).freeze
    @gem = Gem.new(@name)
  end

  protected

  # Main class (subject of project)
  #
  # @return [Class]
  def subject!
    inflector = helper.get(:inflector)
    name = self.name.to_s.gsub('-', '/')

    inflector.constantize(inflector.classify(name))
  end
end
