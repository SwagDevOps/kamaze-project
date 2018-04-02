# frozen_string_literal: true

desc 'Run test suites'
task :test, [:tags] do |task, args|
  tools.fetch(:rspec).tap do |rspec|
    rspec.tags = args[:tags].to_s.split(',').map(&:strip)
  end.run
end
