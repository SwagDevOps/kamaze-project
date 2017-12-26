# frozen_string_literal: true

require "#{__dir__}/lib/swag_dev-project"
require 'swag_dev/project'
require 'sys/proc'

Sys::Proc.progname = nil

SwagDev.project do |c|
  c.subject = SwagDev::Project
  c.name = 'swag_dev-project'
  c.tasks = [
    :'cs:correct', :'cs:control',
    :doc, :'doc:watch',
    :gem, :'gem:compile',
    :shell,
    :'sources:license',
    :test,
    :vagrant,
    :'version:edit',
  ].shuffle
end.load!

task default: [:gem]
