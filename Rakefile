# frozen_string_literal: true

require_relative 'lib/kamaze-project'

require 'rake'
require 'sys/proc'

Sys::Proc.progname = nil

%w[lib tasks].each do |dir|
  Dir.glob("#{__dir__}/rake/#{dir}/*.rb").sort.each { |fp| require fp }
end

task default: [:gem]
