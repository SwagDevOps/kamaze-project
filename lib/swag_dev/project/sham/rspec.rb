# frozen_string_literal: true

require 'swag_dev/project/sham'

SwagDev::Project::Sham.define(:rspec) do |c|
  conf_file  = Pathname.new(Dir.pwd).join('.rspec')
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
