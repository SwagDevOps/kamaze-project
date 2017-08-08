# frozen_string_literal: true

require 'pathname'

unless Kernel.const_defined?('SwagDev')
  module SwagDev
  end
end

class SwagDev::Project
  require 'swag_dev/project/concern/versionable'
  require 'swag_dev/project/concern/helper'
  require 'swag_dev/project/gem'

  include Concern::Versionable
  include Concern::Helper

  # @return [Symbol]
  attr_reader :name

  # @return [Hash]
  attr_reader :version_info

  # @return [Pathname]
  attr_reader :gem

  def initialize
    @name = ENV.fetch('PROJECT_NAME').to_sym
    @version_info = ({
                       version: subject.VERSION.to_s
                     }.merge(subject.version_info)).freeze
    @gem = Gem.new(@name)
  end

  # Main class (subject of project)
  #
  # @return [Class]
  def subject
    inflector = helper.get(:inflector)
    name = self.name.to_s.gsub('-', '/')

    inflector.constantize(inflector.classify(name))
  end
end
