# frozen_string_literal: true

require 'swag_dev/project/helper'
require 'yard'

# Helper based on ``YARD``
class SwagDev::Project::Helper::Yardoc
  # Get a ``YARD::CLI::Yardoc``
  #
  # @param [Array] args
  # @param [String|Pathname] file
  # @return [YARD::CLI::Yardoc]
  def cli(args = [], file = nil)
    yard = YARD::CLI::Yardoc.new
    file = Pathname.new(file || "#{Dir.pwd}/.yardopts")
    if file.file?
      args += Shellwords.split(file.read)
    end

    yard.parse_arguments(args)

    yard
  end
end
