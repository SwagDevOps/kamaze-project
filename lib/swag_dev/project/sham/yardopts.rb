# frozen_string_literal: true

require 'swag_dev/project/sham'
require 'pathname'
require 'shellwords'

SwagDev::Project::Sham.define(:yardopts) do |c|
  conf_file = Pathname.new(Dir.pwd).join('.yardopts')
  options_reader = lambda do |file|
    file.file? ? Shellwords.split(file.read) : []
  end

  c.attributes do
    {
      conf_file: conf_file,
      options:   options_reader.call(conf_file)
    }
  end
end
