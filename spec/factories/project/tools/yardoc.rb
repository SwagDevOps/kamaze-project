# -*- coding: utf-8 -*-
# frozen_string_literal: true

FactoryBot.define do
  factory 'project/tools/yardoc', class: FactoryStruct do
    # Describe instance methods
    describe_instance_methods({
                                options: [0],
                                'options=': [1],
                                log_level: [0],
                                'log_level=': [1],
                                run: [0],
                                call: [0],
                                output_dir: [0],
                                excluded: [0],
                                paths: [0],
                                files: [0],
                              })
  end
end
