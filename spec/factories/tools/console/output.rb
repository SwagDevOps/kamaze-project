# -*- coding: utf-8 -*-
# frozen_string_literal: true

FactoryBot.define do
  factory 'tools/console/output', class: FactoryStruct do
    # Describe instance methods
    describe_instance_methods('tty?': [0],
                              flush: [0],
                              print: [0, 1],
                              puts: [0, 1],
                              write: [1])
  end
end
