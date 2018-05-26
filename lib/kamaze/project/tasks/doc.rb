# coding: utf-8
# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require 'rake/clean'

tools.fetch(:yardoc).tap do |yardoc|
  CLOBBER.include(yardoc.output_dir)
end.yield_self do |yardoc|
  desc 'Generate documentation (using YARD)'
  task doc: [] do |task|
    yardoc.run

    task.reenable
  end
end
