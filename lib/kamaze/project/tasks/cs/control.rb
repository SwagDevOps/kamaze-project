# frozen_string_literal: true

desc 'Run static code analyzer'
task 'cs:control', [:path] do |t, args|
  tools.fetch(:rubocop).prepare do |c|
    c.patterns = args.fetch(:path)
    c.options = ['--parallel']
  end.run

  task.reenable
end
