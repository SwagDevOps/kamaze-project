# frozen_string_literal: true

require 'kamaze/project/concern/observable'

Sham.config(FactoryStruct, :'concern/observable') do |c|
  c.attributes do
    {
      subjecter: lambda do
        Class.new { include Kamaze::Project::Concern::Observable }.new
      end,
    }
  end
end
