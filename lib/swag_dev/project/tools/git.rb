# frozen_string_literal: true

require_relative '../tools'
require_relative 'base_tool'
require 'pathname'
require 'rugged'

# rubocop:disable Style/Documentation
class SwagDev::Project::Tools
  class Git < BaseTool
    # @abstract
    class Util
    end

    class Status
    end

    class Hooks < Util
    end
  end

  [:util,
   :hooks,
   :status].each { |req| require_relative "git/#{req}" }
end
# rubocop:enable Style/Documentation

# Provide a wrapper based on ``rugged`` (``libgit2``}
class SwagDev::Project::Tools::Git
  # @return [String]
  attr_writer :base_dir

  # @see https://github.com/libgit2/rugged
  #
  # @return [Rugged::Repository]
  attr_reader :repository

  # Instance attributes altered during initialization
  #
  # @return [Array<Symbol>]
  def mutable_attributes
    [:base_dir]
  end

  # Get base directory
  #
  # @return [::Pathname]
  def base_dir
    ::Pathname.new(@base_dir)
  end

  def hooks
    Hooks.new(repository)
  end

  # @return [Hash]
  def status
    status = {}
    repository.status do |file, status_data|
      status[file] = status_data
    end

    Status.new(status)
  end

  protected

  def setup
    @base_dir ||= Dir.pwd
    @repository = Rugged::Repository.new(base_dir.to_s)
  end
end
