# frozen_string_literal: true

require_relative '../tools'
require_relative 'base_tool'

class SwagDev::Project::Tools
  class Rspec < BaseTool
  end
end

# Provide wrapper based on top of ``RSpec::Core::Runner``
#
# Sample of use:
#
# ```ruby
# tools.fetch(:rspec).tap do |rspec|
#   rspec.tags = args[:tags].to_s.split(',').map(&:strip)
# end.run
# ```
#
# @see https://www.relishapp.com/rspec/rspec-core/docs/command-line/rake-task
# @see https://github.com/rspec/rspec-core/blob/master/lib/rspec/core/runner.rb
# @see https://relishapp.com/rspec/rspec-core/v/2-4/docs/command-line/tag-option
class SwagDev::Project::Tools::Rspec
  # Default arguments used by ``RSpec::Core::Runner``
  #
  # @type [Array|Arguments]
  # @return [Arguments]
  attr_accessor :defaults

  attr_accessor :stdout

  attr_accessor :stderr

  # @return [Array<String>]
  attr_accessor :tags

  # @type [Boolean]
  # @return [Boolean]
  attr_accessor :fail_on_error

  def mutable_attributes
    [:defaults, :stdout, :stderr, :fail_on_error]
  end

  # Reset arguments
  #
  # @return [self]
  def reset
    @arguments = nil

    self
  end

  def run
    options = arguments.concat(options_arguments).map(&:to_s)
    retcode = core.run(options, stderr, stdout).to_i

    reset.on_error(retcode)
  end

  # Arguments used by ``CLI`` (during execution/``run``)
  #
  # @return [Arguments]
  def arguments
    @arguments = @defaults if @arguments.to_a.size.zero?

    tags.to_a.each do |tag|
      next if @arguments.slice_before('--tag').to_a.include?(['--tag', tag])

      @arguments += ['--tag', tag]
    end

    {
      true  => @arguments,
      false => @arguments.clone.concat(options_arguments).map(&:to_s).freeze
    }.fetch(caller_locations(1..1).first.path == __FILE__)
  end

  # Denote fail (call exit with status code) on error
  #
  # @return [Boolean]
  def fail_on_error?
    !!fail_on_error
  end

  protected

  def setup
    reset

    @tags = []
    @stdout ||= STDOUT
    @stderr ||= STDERR
    @defaults ||= []
    @fail_on_error = true if @fail_on_error.nil?
  end

  # @return [RSpec::Core::Runner]
  def core
    require 'rspec/core'

    RSpec::Core::Runner
  end

  # Abort execution on error
  #
  # @param [Fixnum] code
  # @return [Fixnum]
  def on_error(code)
    (exit(code) if fail_on_error?) unless code.zero?

    code
  end

  def options_arguments
    options_files = Pathname.new(Dir.pwd).join('.rspec')
    defaults = []

    if options_files.file? and options_files.readable?
      defaults += ['-O', '.rspec']
    end

    defaults
  end
end
