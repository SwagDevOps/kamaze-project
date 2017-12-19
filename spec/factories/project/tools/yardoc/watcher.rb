# -*- coding: utf-8 -*-
# frozen_string_literal: true

require 'securerandom'

FactoryBot.define do
  factory 'project/tools/yardoc/watcher', class: FactoryStruct do
    # Describe instance methods
    describe_instance_methods({
                                paths: [0],
                                options: [0],
                                patterns: [0],
                                watch: [0, 1],
                              })
    # @todo test method usable during initialization
    #
    # 'paths=': [1], 'options=': [1], 'patterns=': [1]
    sequence(:random_paths) do |seq|
      @random_paths ||= []

      @random_paths[seq] = Random.new.rand(2...10).times.map do
        SecureRandom.hex[0..8]
      end
    end
  end
end
