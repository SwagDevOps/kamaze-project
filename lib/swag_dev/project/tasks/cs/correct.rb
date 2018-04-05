# frozen_string_literal: true

desc 'Run static code analyzer, auto-correcting offenses'
task 'cs:correct', [:path] do |t, args|
  tools.fetch(:rubocop).prepare do |c|
    c.patterns = args.fetch(:path)
    c.options = ['--auto-correct']
  end.run

  task.reenable
end
