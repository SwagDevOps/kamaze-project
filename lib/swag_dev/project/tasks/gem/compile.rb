# frozen_string_literal: true

require 'rake/clean'
require_relative '../gem'

tools  = SwagDev.project.tools
packer = tools.fetch(:gemspec_packer)

packer.buildables.each do |buildable|
  CLOBBER.include(buildable)

  desc "Compile executable: #{buildable.basename}"
  file buildable => packer.source_files.to_a.map(&:to_s) do
    tools.fetch(:process_locker).lock!(:gemspec_packer) do
      packer.pack(buildable)

      Rake::Task['clobber'].reenable
    end
  end
end
