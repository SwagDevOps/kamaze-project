# frozen_string_literal: true

require_relative '../tools'
require_relative '../concern/cli/with_exit_on_failure'

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
class Kamaze::Project::Tools::Rspec < Kamaze::Project::Tools::BaseTool
  include Kamaze::Project::Concern::Cli::WithExitOnFailure

  # Default arguments used by ``RSpec::Core::Runner``
  #
  # @type [Array|Arguments]
  # @return [Arguments]
  attr_accessor :defaults

  attr_accessor :stdout

  attr_accessor :stderr

  # @return [Array<String>]
  attr_accessor :tags

  def mutable_attributes
    [:defaults, :stdout, :stderr]
  end

  # @raise [SystemExit]
  # @return [self]
  def run
    with_exit_on_failure do
      options = arguments.concat(options_arguments).map(&:to_s)

      self.retcode = core.run(options, stderr, stdout).to_i

      reset
    end

    self
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

  protected

  # Reset arguments + retcode
  #
  # @return [self]
  def reset
    @arguments = nil
    self.retcode = nil

    self
  end

  def setup
    reset

    @tags = []
    @stdout ||= STDOUT
    @stderr ||= STDERR
    @defaults ||= []
  end

  # @return [RSpec::Core::Runner]
  def core
    require 'rspec/core'

    RSpec::Core::Runner
  end

  # @return [Array<String>]
  def options_arguments
    options_files = Pathname.new(Dir.pwd).join('.rspec')
    defaults = []

    if options_files.file? and options_files.readable?
      defaults += ['-O', '.rspec']
    end

    defaults
  end
end
