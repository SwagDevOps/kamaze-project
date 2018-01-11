# frozen_string_literal: true

[
  :constants,
  :progname,
  :factory_struct,
  :configure,
].each { |req| require __FILE__.gsub(/\.rb$/, "/#{req}") }

require_relative '../lib/swag_dev-project'
require_relative '../rake'
