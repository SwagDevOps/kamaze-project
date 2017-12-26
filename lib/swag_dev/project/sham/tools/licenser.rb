# frozen_string_literal: true

# remove

require 'swag_dev/project/sham'

SwagDev::Project::Sham.define('tools/licenser') do |c|
  c.attributes do
    {
      working_dir: SwagDev.project.working_dir,
      license:     SwagDev.project.version_info[:license_header],
      files:       [] # SwagDev.project.gem.spec&.files
    }
  end
end
