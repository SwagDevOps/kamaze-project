# frozen_string_literal: true

require_relative '../cs'

desc 'Run static code analyzer, auto-correcting offenses'
task 'cs:correct', [:path] do |t, args|
  rubocop(args[:path], '--fail-level', 'E', '--auto-correct')
end
