# frozen_string_literal: true

require 'swag_dev/project/sham'

SwagDev::Project::Sham.define('tasks/cs') do |c|
  c.attributes do
    {
      prerequisites: ['gem:gemspec'],
    }
  end
end
