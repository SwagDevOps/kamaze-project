# -*- coding: utf-8 -*-
# frozen_string_literal: true

FactoryBot.define do
  factory 'tools', class: FactoryStruct do
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
          :rspec,
          :rubocop,
          :shell,
          :vagrant,
          :yardoc,
          :yardoc_watcher].shuffle)
  end
end
