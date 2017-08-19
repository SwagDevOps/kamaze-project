# frozen_string_literal: true

require 'swag_dev/project/sham'

project = SwagDev.project
# Instanciate ``YARD::CLI::Yardoc``
#
# @see SwagDev::Project::Helper::Yardoc
SwagDev::Project::Sham.define(:yardoc) do |c|
  c.attributes do
    {
      output_dir: project.yardoc.options[:serializer]&.basepath
    }
  end
end
