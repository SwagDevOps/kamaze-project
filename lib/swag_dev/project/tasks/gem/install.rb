# frozen_string_literal: true
# -*- coding: utf-8 -*-

require 'swag_dev/project'
require 'swag_dev/project/tasks/gem'

desc 'Install gem'
task 'gem:install': ['gem:package'] do
  require 'cliver'

  sh(*[Cliver.detect(:sudo),
       Cliver.detect!(:gem),
       :install,
       project.spec.gem].compact.map(&:to_s))
end
