# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

[nil, :gem_runner, :exceptions].each { |req| require ['rubygems', req].compact.join('/') }

require_relative './build'

# Code mostly based on gem executable
#
# @see http://guides.rubygems.org/publishing/
# @see rubygems-tasks
lambda do
  tools.fetch(:gemspec_builder).yield_self do |builder|
    [:push, builder.buildable].map(&:to_s).yield_self do |args|
      Gem::GemRunner.new.run(args.map(&:to_s))
    rescue Gem::SystemExitException => e
      exit(e.exit_code)
    end
  end
end.tap do |runner|
  desc 'Push gem up to the gem server'
  task('gem:push': [:'gem:build']) { runner.call }
end
