# -*- coding: utf-8 -*-
# frozen_string_literal: true

FactoryBot.define do
  factory 'tools/console/output', class: FactoryStruct do
    # Describe instance methods
    describe_instance_methods({
                                writeln: [1, 2],
                              })
  end
end
