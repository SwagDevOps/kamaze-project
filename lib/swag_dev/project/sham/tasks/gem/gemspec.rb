# frozen_string_literal: true

require 'swag_dev/project/sham'

SwagDev::Project::Sham.define('tasks/gem/gemspec') do |c|
  template = 'gemspec.tpl'
  libfiles = (SwagDev.project.gem.spec&.files).to_a.sort

  c.attributes do
    {
      template: template,
      files:    [template] + libfiles,
    }
  end
end
