# -*- coding: utf-8 -*-
# frozen_string_literal: true

FactoryBot.define do
  factory 'tools', class: FactoryStruct do
    # Describe instance methods
    #
    # { method_name: arguments_count [Array] }
    #
    # @todo use a custom matcher [DRY]
    describe_instance_methods(to_h: [0],
                              get: [1],
                              fetch: [1],
                              '[]': [1],
                              'member?' => [1])

    # keys COULD be in a different order from the given class
    #
    # Usable in context '#to_h' (keys)
    keys([:console,
          :gemspec_builder,
          :gemspec_packer,
          :gemspec_reader,
          :gemspec_writer,
          :git,
          :licenser,
          :process_locker,
          :rubocop,
          :vagrant,
          :yardoc,
          :yardoc_watcher].shuffle)
  end
end
