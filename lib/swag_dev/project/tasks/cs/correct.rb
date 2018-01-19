# frozen_string_literal: true

require_relative '../cs'

desc 'Run static code analyzer, auto-correcting offenses'
task 'cs:correct', [:path] do |t, args|
  SwagDev.project.tools.fetch(:rubocop).prepare do |c|
    c.patterns = args.fetch(:path)
    c.options = ['--auto-correct']
  end.run
end
