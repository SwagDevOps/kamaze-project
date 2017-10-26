# -*- coding: utf-8 -*-

require 'factory_bot'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  FactoryBot.find_definitions

  # Build is defined on a root level to be available outside of examples
  def build(name)
    FactoryBot.build(name)
  end
end
