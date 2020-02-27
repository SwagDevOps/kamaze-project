# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

desc 'Run static code analyzer'
task 'cs:control', [:path] do |t, args|
  tools.fetch(:rubocop).prepare do |c|
    c.patterns = args.fetch(:path)
    c.options = ['--parallel']
  end.run

  task.reenable
end
