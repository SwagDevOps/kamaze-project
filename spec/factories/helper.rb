# -*- coding: utf-8 -*-
# frozen_string_literal: true

require 'kamaze/project/helper'
require 'kamaze/project/helper/inflector'
require 'kamaze/project/helper/project'
require 'kamaze/project/helper/project/config'

FactoryBot.define do
  factory 'helper', class: FactoryStruct do
    # subject build using protected ``new``
    sequence(:subject) do |seq|
      @subjects ||= []

      @subjects[seq] = Kamaze::Project::Helper.__send__(:new)
    end

    # helpers as key: expected_class
    helpers(inflector: Kamaze::Project::Helper::Inflector,
            project: Kamaze::Project::Helper::Project,
            'project/config': Kamaze::Project::Helper::Project::Config)
  end
end
