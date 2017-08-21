# frozen_string_literal: true

require 'swag_dev/project/dsl'

# More convenient than ``bundle exec pry``
desc 'Start ruby REPL'
task :shell do
  require 'pry'

  banner = proc do
    patch = defined?(RUBY_PATCHLEVEL) ? 'p%s' % RUBY_PATCHLEVEL : nil
    parts = ['Ruby',
             '%s%s' % [RUBY_VERSION, patch],
             '(%s revision %s)' % [RUBY_RELEASE_DATE, RUBY_REVISION],
             '[%s]' % RUBY_PLATFORM]

    console.stdout.writeln(parts.join(' '), :green)
  end

  banner.call
  Pry.start
end
