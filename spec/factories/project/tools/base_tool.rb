# -*- coding: utf-8 -*-
# frozen_string_literal: true

FactoryBot.define do
  factory 'project/tools/base_tool', class: FactoryStruct do
    # Describe instance methods
    describe_instance_methods({ mutable_attributes: [0] })
  end
end
