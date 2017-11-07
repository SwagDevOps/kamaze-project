# frozen_string_literal: true

require 'swag_dev/project/tools'
require 'swag_dev/project/tools/packager/filesystem'

# Provides a packager
#
# Packager is intended to provide basic packaging operations
class SwagDev::Project::Tools::Packager
  # Get filesystem
  #
  # @return [SwagDev::Project::Tools::Packager::Filesystem]
  attr_reader :fs

  def initialize
    @initialized = false
    yield self if block_given?
    @fs ||= filesystem
    [:files].each do |m|
      self.singleton_class.class_eval { protected "#{m}=" }
    end
    @initialized = true
  end

  # Set files used during packaging
  #
  # @param [Array<String|Pathname>]
  def files=(files)
    @fs = filesystem(files)

    files
  end

  # Get files
  #
  # @return [Array<Pathname>]
  def files
    fs.source_files
  end

  # Denote class is initialized
  #
  # @return [Boolean]
  def initialized?
    @initialized
  end

  def method_missing(method, *args, &block)
    if respond_to_missing?(method)
      fs.public_send(method, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(method, include_private = false)
    unless initialized? and method.to_s[-1] == '='
      return true if fs.respond_to?(method, include_private)
    end

    super(method, include_private)
  end

  protected

  # Initialize a new filesystem
  #
  # @return [SwagDev::Project::Tools::Packager::Filesystem]
  def filesystem(files = [])
    self.class.const_get(:Filesystem).new do |fs|
      fs.source_files = files
    end
  end
end
