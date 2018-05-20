# frozen_string_literal: true

desc 'Edit version file'
task 'version:edit' do |task|
  require 'tty/editor'

  TTY::Editor.open(project.version.to_path).yield_self do |b|
    task.reenable if b
  end
end
