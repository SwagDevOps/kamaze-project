# -*- coding: utf-8 -*-
# frozen_string_literal: true

require 'securerandom'

FactoryBot.define do
  factory 'tools/yardoc/watcher', class: FactoryStruct do
    # Describe instance methods
    describe_instance_methods({
                                paths: [0],
                                options: [0],
                                patterns: [0],
                                watch: [0, 1],
                              })

    # sequences usable during initialization
    #
    # 'paths=', 'options=', 'patterns='
    sequence(:random_paths) do |seq|
      @random_paths ||= []

      @random_paths[seq] = Random.new.rand(2...10).times.map do
        SecureRandom.hex[0..8]
      end
    end

    sequence(:random_patterns) do |seq|
      @random_patterns ||= []

      @random_patterns[seq] = Random.new.rand(2...10).times.map do
        SecureRandom.hex[0..8]
      end
    end

    sequence(:random_options) do |seq|
      @random_options ||= {}

      @random_options[seq] = {
        only: Regexp.new(Random.new.rand(2...10).times.map do
          '\.%s$' % SecureRandom.hex[0..2]
        end.join('|')),
        ignore: Regexp.new(Random.new.rand(2...10).times.map do
          '%s/' % SecureRandom.hex[0..6]
        end.join('|'))
      }
    end
  end
end
