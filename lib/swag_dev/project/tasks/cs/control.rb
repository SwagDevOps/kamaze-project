# frozen_string_literal: true

require_relative '../cs'

desc 'Run static code analyzer'
task 'cs:control', [:path] do |t, args|
  SwagDev.project.tools.fetch(:rubocop).prepare do |config|
    config.patterns = args.fetch(:path)
    config.options = ['--fail-level', 'E']
  end.run
end
