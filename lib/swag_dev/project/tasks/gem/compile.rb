# frozen_string_literal: true

require 'swag_dev/project/dsl'
require 'swag_dev/project/tasks/gem'

# tasks --------------------------------------------------------------

# CLOBBER.include(sham!.build_dirs.values)

packer = project.tools.fetch(:packer)

unless packer.executables.empty?
  (desc "Compile executable%s #{packer.executables}" % {
    true => nil,
    false => 's'
  }[1 == packer.executables.size])
end
task 'gem:compile': ['gem:package'] do
  project.tools
         .fetch(:process_locker)
         .lock!('gem-compile') { packer.pack }
end
