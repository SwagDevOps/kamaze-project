# frozen_string_literal: true

require 'swag_dev/project/dsl'
require 'swag_dev/project/tasks/gem'

# tasks --------------------------------------------------------------

tools  = project.tools
packer = tools.fetch(:packer)

# clobber ``build`` directory SHOULD NOT be a good idea
#
# CLOBBER.include(packer.build_dir)

packer.build_dirs.each do |k, dir|
  directory dir => ['gem:package'] do
    mkdir_p(dir)
  end
end

packer.buildables.each do |buildable|
  CLOBBER.include(buildable)

  desc "Compile #{buildable.basename}"
  file buildable => packer.build_dirs.values do
    tools.fetch(:process_locker).lock!('gem-compile') do
      packer = tools.fetch(:packer)
      # packer.__send__('compiler=', :true)

      packer.pack(buildable)
    end
  end
end
