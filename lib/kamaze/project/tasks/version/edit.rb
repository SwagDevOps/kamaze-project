# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

desc 'Edit version file'
task 'version:edit' do |task|
  require 'tty/editor'

  TTY::Editor.open(project.version.to_path).yield_self do |b|
    task.reenable if b
  end
end
