# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require 'rake/clean'
require_relative '../gem'

packer = tools.fetch(:gemspec_packer)
writer = tools.fetch(:gemspec_writer)

# generate gemspec file (when missing) -------------------------------
writer.write unless packer.ready?

# tasks --------------------------------------------------------------
packer.packables.each do |packable|
  CLOBBER.include(packable)

  desc "Compile executable: #{packable.basename}"
  file packable => packer.source_files.to_a.map(&:to_s) do
    tools.fetch(:process_locker).lock!(:gemspec_packer) do
      packer.pack(packable)

      Rake::Task['clobber'].reenable
    end
  end
end
