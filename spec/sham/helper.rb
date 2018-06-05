# frozen_string_literal: true

require 'kamaze/project/helper'
require 'kamaze/project/helper/inflector'
require 'kamaze/project/helper/project'
require 'kamaze/project/helper/project/config'

Sham.config(FactoryStruct, File.basename(__FILE__, '.*').to_sym) do |c|
  c.attributes do
    {
      subjecter: -> { Kamaze::Project::Helper.__send__(:new) },
      classes: {
        inflector: Kamaze::Project::Helper::Inflector,
        project: Kamaze::Project::Helper::Project,
        'project/config': Kamaze::Project::Helper::Project::Config
      }
    }
  end
end
