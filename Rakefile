# frozen_string_literal: true

require "#{__dir__}/lib/swag_dev-project"
require 'swag_dev/project/dsl'
require 'sys/proc'

Sys::Proc.progname = nil

project do |c|
  c.subject = SwagDev::Project
  c.name    = 'swag_dev-project'
  c.tasks   = [
    :'cs:correct', :'cs:control',
    :doc, :'doc:watch',
    :gem, :'gem:compile',
    :shell,
    :'sources:license',
    :test,
    :vagrant,
    :'version:edit',
  ].shuffle
end

task default: [:gem]
