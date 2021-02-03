# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# @type [Kamaze::Project::Tools::Gemspec::Writer] writer
tools.fetch(:gemspec_writer).tap do |writer|
  writer.write(preserve_mtime: true) unless writer.generated.file?

  # Require base tasks ----------------------------------------------
  [:gemspec, :build].each { |req| require_relative "gem/#{req}" }

  # Default task ----------------------------------------------------
  desc 'Build all the packages'
  # rubocop:disable Style/SymbolProc
  task(gem: [writer.to_s, :'gem:build']) do |task|
    task.reenable
  end
  # rubocop:enable Style/SymbolProc
end
