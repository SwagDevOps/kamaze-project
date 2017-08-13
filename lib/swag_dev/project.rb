# frozen_string_literal: true

require 'pathname'

module SwagDev
  class Project
    [
      'concern/helper',
      'concern/sham',
      'concern/versionable',
      'gem'
    ].each { |req| require "swag_dev/project/#{req}" }

    include Concern::Helper
    include Concern::Sham
    include Concern::Versionable
  end

  class << self
    include Project::Concern::Helper

    # Get an instance of project
    #
    # @return [SwagDev::Project]
    def project
      helper.get(:project)
    end
  end
end

class SwagDev::Project
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

  # Get an instance of ``YARD::CLI::Yardoc`` based on current environment
  #
  # @return [YARD::CLI::Yardoc]
  def yardoc
    helper.get('yardoc').cli
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
