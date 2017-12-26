# frozen_string_literal: true

require 'swag_dev/project'

desc 'Edit version file'
task 'version:edit' do
  require 'tty/editor'

  TTY::Editor.open(SwagDev.project.subject.VERSION.file_name)
end
