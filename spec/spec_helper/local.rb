# frozen_string_literal: true

require_relative 'factory_struct'

# Local (helper) methods
module Local
  protected

  # Retrieve ``sham`` by given ``name``
  #
  # @param [Symbol] name
  def sham!(name)
    name = name.to_sym

    FactoryStruct.sham!(name)
  end
end
