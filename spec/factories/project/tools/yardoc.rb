# -*- coding: utf-8 -*-
# frozen_string_literal: true

FactoryBot.define do
  factory 'project/tools/yardoc', class: FactoryStruct do
    # Describe instance methods
    describe_instance_methods({
                                options: [0],
                                run: [0],
                                call: [0],
                                output_dir: [0],
                                excluded: [0],
                              })
  end
end
