# frozen_string_literal: true

require 'active_support/concern'
require 'yard'
require 'shellwords'

require 'swag_dev/project/concern'

# Get a real instance of ``YARD::CLI::Yardoc`
module SwagDev::Project::Concern::Yardoc
  extend ActiveSupport::Concern

  # Get an instance of ``YARD::CLI::Yardoc``
  #   based on current environment and configuration
  #
  # @return [YARD::CLI::Yardoc]
  def yardoc
    @yardoc ||= yardoc_cli(working_dir)

    @yardoc
  end

  protected

  # Get a ``YARD::CLI::Yardoc``
  #
  # @param [String|Pathname] working_dir
  # @param [Array] args
  # @return [YARD::CLI::Yardoc]
  def yardoc_cli(working_dir = Dir.pwd, args = [])
    yard = YARD::CLI::Yardoc.new
    file = Pathname.new("#{working_dir}/.yardopts")
    args = (args + Shellwords.split(file.read)) if file.file?

    yard.parse_arguments(args)

    yard
  end
end
