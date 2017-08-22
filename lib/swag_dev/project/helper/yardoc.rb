# frozen_string_literal: true

require 'swag_dev/project/helper'
require 'yard'
require 'shellwords'

# Helper based on ``YARD``
class SwagDev::Project::Helper::Yardoc
  # Get a ``YARD::CLI::Yardoc``
  #
  # @param [String|Pathname] working_dir
  # @param [Array] args
  # @return [YARD::CLI::Yardoc]
  def cli(working_dir = Dir.pwd, args = [])
    yard = YARD::CLI::Yardoc.new
    file = Pathname.new("#{working_dir}/.yardopts")
    args = (args + Shellwords.split(file.read)) if file.file?

    yard.parse_arguments(args)

    yard
  end
end
