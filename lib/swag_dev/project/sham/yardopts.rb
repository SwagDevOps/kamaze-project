# frozen_string_literal: true

require 'swag_dev/project/sham'
require 'pathname'
require 'shellwords'

SwagDev::Project::Sham.define(:yardopts) do |c|
  yardopts_file  = Pathname.new(Dir.pwd).join('.yardopts')
  options_reader = lambda do |file|
    file.file? ? Shellwords.split(file.read) : []
  end

  c.attributes do
    {
      file:    yardopts_file,
      options: options_reader.call(yardopts_file)
    }
  end
end
