# frozen_string_literal: true

require_relative '../status'
require_relative 'file'
require 'pathname'

# Buffer
class SwagDev::Project::Tools::Git::Status::Buffer
  def initialize(content)
    @content = content.tr("\000", "\n").freeze
  end

  def to_s
    content
  end

  # Get matchers
  #
  # @return [Hash{Symbol => Regexp}]
  def matchers
    {
      staged: /^[A-Z]/,
      unstaged: /^\s/,
      untracked: /^\?/,
    }
  end

  # Parse output
  #
  # @return [{Symbol => String}]
  def parse
    output = matchers.map { |k, v| [k, []] }.to_h

    preparse.each do |k, v|
      v.each do |filepath|
        add_filepath(output, filepath, k)
      end
    end

    output
  end

  # Fast parse to a ``Hash`` (naive)
  #
  # @return [{String => String}]
  def preparse
    parsed = {}
    # git status -z --untracked-files=all | sed "s/\x0/\n/g"
    self.to_s.lines.each do |line|
      match = /^([M|A|R|C|D|U|\?|\s]{2})[ ]{1}(.*)/.match(line)

      (parsed[match[1]] ||= []).push(match[2]) unless match.nil?
    end

    parsed
  end

  protected

  attr_reader :content

  # Add filepath on output using flag
  #
  # @param [Hash] result where files are stored by type
  # @param [String] filepath
  # @param [String] flag
  # @return [nil|Object]
  #
  # @see https://git-scm.com/docs/git-status
  def add_filepath(result, filepath, flag)
    file_class = SwagDev::Project::Tools::Git::Status::File

    matchers.each do |type, reg|
      next unless reg =~ flag

      return result[type] << file_class.new(filepath, flag, Dir.pwd).freeze
    end
  end
end
