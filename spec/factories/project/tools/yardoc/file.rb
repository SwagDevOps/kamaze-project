# -*- coding: utf-8 -*-
# frozen_string_literal: true

FactoryBot.define do
  factory 'project/tools/yardoc/file', class: FactoryStruct do
    # Describe instance methods
    describe_instance_methods({
                                paths: [0],
                                to_a: [0],
                                'glob?': [0],
                              })
  end
end
