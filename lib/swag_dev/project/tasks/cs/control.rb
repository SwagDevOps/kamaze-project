# frozen_string_literal: true

require_relative '../cs'

desc 'Run static code analyzer'
task 'cs:control', [:path] do |t, args|
  rubocop(args[:path], '--fail-level', 'E')
end
