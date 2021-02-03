# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

[nil, :gem_runner, :exceptions].each { |req| require ['rubygems', req].compact.join('/') }

tools.fetch(:gemspec_builder).tap do |builder|
  # Code mostly based on gem executable
  #
  # @see http://guides.rubygems.org/publishing/
  # @see rubygems-tasks
  runner = lambda do
    [:push, builder.buildable].map(&:to_s).yield_self do |args|
      Gem::GemRunner.new.run(args.map(&:to_s))
    rescue Gem::SystemExitException => e
      exit(e.exit_code)
    end
  end

  desc 'Push gem up to the gem server'
  task('gem:push': [builder.buildable]) { runner.call }
end
