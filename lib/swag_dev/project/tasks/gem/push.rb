# frozen_string_literal: true

[nil, :gem_runner, :exceptions].each do |req|
  require "rubygems/#{req}".rstrip('/')
end

# Code mostly based on gem executable
#
# @see http://guides.rubygems.org/publishing/
# @see rubygems-tasks
builder = tools.fetch(:gemspec_builder)
desc 'Push gem up to the gem server'
task 'gem:push': [builder.buildable] do
  args = [:push, builder.buildable].map(&:to_s)

  begin
    Gem::GemRunner.new.run(args.map(&:to_s))
  rescue Gem::SystemExitException => e
    exit(e.exit_code)
  end
end
