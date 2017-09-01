# frozen_string_literal: true

require "#{__dir__}/lib/swag_dev-project"
require 'swag_dev/project/dsl'

project do |c|
  c.tasks = [
    'cs/correct', 'cs/control',
    :doc, 'doc/watch',
    :gem, 'gem/compile',
    :shell,
    'version/edit',
  ].shuffle
end

task default: [:gem]
