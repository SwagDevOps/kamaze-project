# frozen_string_literal: true

require 'swag_dev/project/sham'
require 'swag_dev/project/sham/yardopts'

require 'pathname'
require 'shellwords'

SwagDev::Project::Sham.define('tasks/doc') do |c|
  c.attributes do
    {
      yardopts: SwagDev.project.sham!(:yardopts),
      ignored_patterns: [
        %r{/\.#},
        /_flymake\.rb$/,
      ]
    }
  end
end
