# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require "#{__dir__}/lib/swag_dev-project"

['gem', 'gem/compile', 'doc', 'doc/watch'].each do |req|
  require "swag_dev/project/tasks/#{req}"
end

task default: [:gem]
