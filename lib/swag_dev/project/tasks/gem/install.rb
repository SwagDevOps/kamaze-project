# frozen_string_literal: true
# -*- coding: utf-8 -*-

require 'cliver'
require_relative '../gem'

desc 'Install gem'
task 'gem:install': ['gem:build'] do
  project = SwagDev.project
  command = [
    Cliver.detect(:sudo),
    Cliver.detect!(:gem),
    :install,
    '-u',
    '--verbose',
    '--no-document',
    '--clear-sources',
    project.tools.fetch(:gemspec_builder).buildable
  ].compact.map(&:to_s)

  sh(*command)
end
