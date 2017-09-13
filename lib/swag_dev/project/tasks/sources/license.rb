# frozen_string_literal: true

require 'swag_dev/project/dsl'
require 'swag_dev/project/tasks/sources'

sham!
desc 'Apply license on source files'
task 'sources:license', [:output] => sham!.prerequisites do |task, args|
  output = args[:output] ? Pathname.new(args[:output]) : nil

  project.tools.get(:licenser).process do |process|
    process.output = output if output
  end
end
