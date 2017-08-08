# frozen_string_literal: true

require 'swag_dev/project'
require 'swag_dev/project/tasks/gem'
require 'rake/clean'

project      = SwagDev::Project.new
dependencies = ['gem:gemspec'] + (project.gem.spec&.files).to_a

CLOBBER.include('pkg')

namespace :gem do
  task package: FileList.new(*dependencies) do
    require 'rubygems/package_task'
    require 'securerandom'

    # internal namespace name
    ns = '_%s' % SecureRandom.hex(4)
    namespace ns do
      task = Gem::PackageTask.new(project.gem.spec)
      task.define
      # Task management
      begin
        Rake::Task['%s:package' % ns].invoke
      rescue Gem::InvalidSpecificationException => e
        STDERR.puts(e)
        exit 1
      end
      Rake::Task['clobber'].reenable
    end
  end
end
