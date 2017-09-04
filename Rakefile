# frozen_string_literal: true

require "#{__dir__}/lib/swag_dev-project"
require 'swag_dev/project/dsl'

project do |c|
  c.subject = SwagDev::Project
  c.name    = 'swag_dev-project'
  c.tasks   = [
    :'cs:correct', :'cs:control',
    :doc, :'doc:watch',
    :gem, :'gem:compile',
    :shell,
    :test,
    :'version:edit',
  ].shuffle
end

task default: [:gem]
