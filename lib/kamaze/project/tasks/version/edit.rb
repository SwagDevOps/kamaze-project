# frozen_string_literal: true

desc 'Edit version file'
task 'version:edit' do |task|
  require 'tty/editor'

  TTY::Editor.open(project.subject.VERSION.file_name)
  task.reenable
end
