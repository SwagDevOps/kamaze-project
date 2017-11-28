# frozen_string_literal: true

require_relative '../sources'

licenser = SwagDev.project.tools.fetch(:licenser)

desc 'Apply license on source files'
task 'sources:license', [:output] => ['gem:gemspec'] do |task, args|
  output = args[:output] ? Pathname.new(args[:output]) : nil

  licenser.process do |process|
    process.output = output if output
  end
end
