# frozen_string_literal: true

writer = tools.fetch(:gemspec_writer)

desc 'Apply license on (ruby) source files'
task 'sources:license', [:output] => [writer.to_s] do |task, args|
  output  = args[:output] ? Pathname.new(args[:output]) : nil
  builder = tools.fetch(:gemspec_builder)
  version = project.subject.const_get('VERSION')

  begin
    tools.fetch(:licenser).process do |process|
      process.output  = output if output
      process.license = version.fetch(:license_header)
      process.files   = builder.source_files.select do |file|
        # @todo use a better ruby files recognition
        file.extname.gsub(/^\./, '') == 'rb'
      end
    end
  rescue SystemExit, Interrupt
    exit(Errno::ECANCELED::Errno)
  rescue Errno::EPIPE => e
    exit(e.class.const_get(:Errno))
  end
end
