# frozen_string_literal: true

require 'swag_dev/project/sham/tasks/doc'

SwagDev::Project::Sham.define('tasks/doc/watch') do |c|
  c.attributes do
    {
      listen_options: {
        only:   %r{\.rb$},
        ignore: SwagDev.project
                       .sham!('tasks/doc')
                       .ignored_patterns
                       .map { |pattern| %r{#{pattern}} }
      }
    }
  end
end
