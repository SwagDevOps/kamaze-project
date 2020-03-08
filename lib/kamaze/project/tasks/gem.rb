# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# Require base tasks ------------------------------------------------
[:gemspec, :build].each { |req| require_relative "gem/#{req}" }

lambda do |method, *args|
  tools.fetch(:gemspec_writer).public_send(*[method].push(*args))
end.tap do |writer|
  # Default task ----------------------------------------------------
  desc 'Build all the packages'
  task gem: [writer.call(:to_s), :'gem:build'] do |task| # rubocop:disable Style/SymbolProc
    task.reenable
  end
end
