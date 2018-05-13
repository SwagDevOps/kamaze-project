# frozen_string_literal: true

builder = tools.fetch(:gemspec_builder)

desc 'Install gem'
task 'gem:install': [builder.buildable] do |task|
  require 'cliver'

  command = [
    [Cliver.detect(:sudo) ? [:sudo, '-H'] : nil],
    [Cliver.detect!(:gem),
     :install,
     '--update-sources',
     '--clear-sources',
     '--no-user-install',
     '--norc',
     '--no-document',
     builder.buildable]
  ].flatten.compact.map(&:to_s)

  begin
    sh(*command, verbose: false)
  rescue SystemExit, Interrupt
    exit(Errno::ECANCELED::Errno)
  end
end
