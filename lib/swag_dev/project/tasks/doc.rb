# coding: utf-8
# frozen_string_literal: true

require 'swag_dev/project'
require 'rake/clean'

yardoc = SwagDev.project.tools.fetch(:yardoc)

# clobber -----------------------------------------------------------

CLOBBER.include(yardoc.output_dir)

# tasks -------------------------------------------------------------

desc 'Generate documentation (using YARD)'
task doc: [] do
  yardoc.run
end
