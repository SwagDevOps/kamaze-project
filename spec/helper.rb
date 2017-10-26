# frozen_string_literal: true

[
  :progname,
  :factory_struct,
  :configure,
].each { |s| require [__dir__, 'helper', s].map(&:to_s).join('/') }

require "#{__dir__}/../lib/swag_dev-project"
