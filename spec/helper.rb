# frozen_string_literal: true

[
  :constants,
  :progname,
  :factory_struct,
  :configure,
].each { |s| require [__dir__, 'helper', s].map(&:to_s).join('/') }

require_relative '../lib/swag_dev-project'
require_relative '../rake'
