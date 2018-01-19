# frozen_string_literal: true

require 'cliver'
require_relative 'build'

desc 'Install gem'
task 'gem:install': ['gem:build'] do
  command = [
    Cliver.detect(:sudo),
    Cliver.detect!(:gem),
    :install,
    '--update-sources',
    '--clear-sources',
    '--no-user-install',
    '--norc',
    '--no-document',
    SwagDev.project.tools.fetch(:gemspec_builder).buildable
  ].compact.map(&:to_s)

  sh(*command, verbose: false)
end
