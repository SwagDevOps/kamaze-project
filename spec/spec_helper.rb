# frozen_string_literal: true

[
  'lib/swag_dev-project',
  'rake'
].each { |req| require_relative "../#{req}" }

[
  :constants,
  :progname,
  :factory_struct,
  :configure,
].each { |req| require __FILE__.gsub(/\.rb$/, "/#{req}") }
