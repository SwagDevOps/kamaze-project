# coding: utf-8
# frozen_string_literal: true

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
