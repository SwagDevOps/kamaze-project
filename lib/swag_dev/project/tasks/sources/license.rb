# frozen_string_literal: true

require_relative '../sources'

desc 'Apply license on (ruby) source files'
task 'sources:license', [:output] => ['gem:gemspec'] do |task, args|
  output   = args[:output] ? Pathname.new(args[:output]) : nil

  project  = SwagDev.project
  licenser = project.tools.fetch(:licenser)
  builder  = project.tools.fetch(:gemspec_builder)

  licenser.process do |process|
    process.output  = output if output
    process.license = project.version_info.fetch(:license_header)
    process.files   = builder.source_files.select do |file|
      # @todo use a better ruby files recognition
      file.extname.gsub(/^\./, '') == 'rb'
    end
  end
end
