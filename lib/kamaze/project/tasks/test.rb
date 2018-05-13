# frozen_string_literal: true

desc 'Run test suites'
task :test do |task, args|
  tags = args.extras

  tools.fetch(:rspec).tap do |rspec|
    rspec.tags = tags
  end.run
end
