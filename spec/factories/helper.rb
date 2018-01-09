# -*- coding: utf-8 -*-
# frozen_string_literal: true

require 'swag_dev/project/helper'
require 'swag_dev/project/helper/inflector'
require 'swag_dev/project/helper/project'
require 'swag_dev/project/helper/project/config'

FactoryBot.define do
  factory 'helper', class: FactoryStruct do
    # subject build using protected ``new``
    sequence(:subject) do |seq|
      @subjects ||= []

      @subjects[seq] = SwagDev::Project::Helper.__send__(:new)
    end

    # helpers as key: expected_class
    helpers(inflector: SwagDev::Project::Helper::Inflector,
            project: SwagDev::Project::Helper::Project,
            'project/config': SwagDev::Project::Helper::Project::Config)
  end
end
