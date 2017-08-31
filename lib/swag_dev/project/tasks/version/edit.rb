# frozen_string_literal: true

require 'swag_dev/project/dsl'

desc 'Edit version file'
task 'version:edit' do
  require 'tty/editor'

  TTY::Editor.open(project.subject.VERSION.file_name)
end
