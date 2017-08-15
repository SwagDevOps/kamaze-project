# frozen_string_literal: true

require 'swag_dev/project'
require 'swag_dev/project/sham'

project  = SwagDev.project
template = 'gemspec.tpl'

SwagDev::Project::Sham.define('tasks/gem/gemspec') do |c|
  c.attributes do
    {
      template:     template,
      dependencies: [template] + (project.gem.spec&.files).to_a,
    }
  end
end
