# frozen_string_literal: true

# Provides a task intented to easily start pry REPL
#
# * more convenient than ``bundle exec pry``
# * displays ``RUBY_DESCRIPTION`` (variant) on startup

tools  = SwagDev.project.tools

# banner -------------------------------------------------------------
banner = lambda do
  patch = defined?(RUBY_PATCHLEVEL) ? "p#{RUBY_PATCHLEVEL}" : nil
  # almost like RUBY_DESCRIPTION
  descr = ["#{RUBY_ENGINE} #{RUBY_VERSION}#{patch}".rstrip,
           "(#{RUBY_RELEASE_DATE})",
           "[#{RUBY_PLATFORM}]"].join(' ')

  tools.fetch(:console).stdout.puts("{{green:#{descr}}}")
end

# shell --------------------------------------------------------------
shell = lambda do
  require 'pry'

  Pry.start
end

# task ---------------------------------------------------------------
desc 'Start ruby REPL'
task :shell do
  [banner, shell].map { |t| Thread.new { t.call } }.each(&:join)
end
