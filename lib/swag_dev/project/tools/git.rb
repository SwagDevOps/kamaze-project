# frozen_string_literal: true

require_relative '../tools'
require_relative 'base_tool'
require 'pathname'

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

  # Get hooks
  #
  # @return [Hooks]
  def hooks
    Hooks.new(self)
  end

  # Get status
  #
  # @return [Hash]
  def status
    status = {}
    repository.status { |file, data| status[file] = data }

    Status.new(status)
  end

  # Denote is a repository
  #
  # @return [Boolean]
  def repository?
    !!repository
  end

  protected

  def setup
    @base_dir ||= Dir.pwd
    begin
      require 'rugged'
      @repository = Rugged::Repository.new(base_dir.to_s)
    rescue LoadError, Rugged::RepositoryError
      # @todo Load error SHOULD be stored (as a boolean?)
      @repository = nil
    end
  end
end
