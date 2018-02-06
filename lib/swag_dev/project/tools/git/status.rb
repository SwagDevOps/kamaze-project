# frozen_string_literal: true

require_relative '../git'
require_relative 'status/file'
require 'pathname'

# Provide status
#
# Capture a buffer (from a command) and provide a parsed result
class SwagDev::Project::Tools::Git::Status
  attr_reader :base_dir

  def initialize(status, base_dir = Dir.pwd)
    @base_dir = ::Pathname.new(base_dir)
    @status = status.clone
  end

  # @todo Implement
  # @return [Hash{Symbol => Haah{String => File}}]
  def to_h
    output = { index: {}, worktree: {}, ignored: {} }

    output
  end

  # @return [Array<File>]
  def to_a
    prepared.to_a.map do |v|
      File.new(v.fetch(0), v.fetch(1), base_dir).freeze
    end
  end

  protected

  # Get prepared filepaths with symbols (states)
  #
  # @return [Hash{String => Array<Symbol>}]
  def prepared
    output = {}
    @status.each do |file, status_data|
      status_data.each do |status|
        status = status.to_s.split('_').map(&:to_sym)

        output[file] = (output[file] || []).concat(status).uniq.sort
      end
    end

    output
  end
end
