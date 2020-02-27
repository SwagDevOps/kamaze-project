# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

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
