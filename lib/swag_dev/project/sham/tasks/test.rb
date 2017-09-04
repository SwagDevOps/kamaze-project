# frozen_string_literal: true

require 'swag_dev/project/sham'
require 'swag_dev/project/sham/rspec'

SwagDev::Project::Sham.define('tasks/test') do |c|
  c.attributes do
    {
      rspec: SwagDev.project.sham!(:rspec),
    }
  end
end
