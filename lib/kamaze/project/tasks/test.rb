# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

desc 'Run test suites'
task :test do |task, args|
  tags = args.extras

  tools.fetch(:rspec).tap do |rspec|
    rspec.tags = tags
  end.run
end
