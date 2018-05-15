# frozen_string_literal: true

[
  'lib/kamaze-project',
  'rake'
].each { |req| require_relative "../#{req}" }

[
  :env,
  :constants,
  :progname,
  :factory_struct,
  :configure,
].each { |req| require __FILE__.gsub(/\.rb$/, "/#{req}") }
