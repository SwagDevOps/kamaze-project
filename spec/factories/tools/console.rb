# -*- coding: utf-8 -*-

FactoryBot.define do
  factory 'tools/console', class: FactoryStruct do
    # Describe instance methods
    describe_instance_methods({
                                stdout: [0],
                                stderr: [0],
                              })
  end
end
