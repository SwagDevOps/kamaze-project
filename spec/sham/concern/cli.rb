# frozen_string_literal: true

require 'kamaze/project/concern/cli'

Sham.config(FactoryStruct, :'concern/cli') do |c|
  c.attributes do
    {
      subjecter: lambda do
        Class.new do
          include Kamaze::Project::Concern::Cli
        end.new
      end
    }
  end
end
