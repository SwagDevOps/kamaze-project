# frozen_string_literal: true

require 'rake/clean'
require_relative '../gem'

tools  = SwagDev.project.tools
packer = tools.fetch(:gemspec_packer)

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
