# frozen_string_literal: true
# -*- coding: utf-8 -*-

require 'cliver'
require_relative '../gem'

project = SwagDev.project
builder = project.tools.fetch(:gemspec_builder)

desc 'Install gem'
task 'gem:install': ['gem:build'] do
  sh(*[Cliver.detect(:sudo),
       Cliver.detect!(:gem),
       :install,
       '-u',
       '--verbose',
       '--no-document',
       '--clear-sources',
       project.gem.package].compact.map(&:to_s))
end
