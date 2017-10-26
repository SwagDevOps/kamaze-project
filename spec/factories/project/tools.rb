# -*- coding: utf-8 -*-
# frozen_string_literal: true

FactoryBot.define do
  factory 'project/tools', class: FactoryStruct do
    # keys COULD be in a different from the given class
    #
    # Usable in context '#to_h' (keys)
    keys([:gemspec_writer,
          :gemspec_reader,
          :gemspec_builder,
          :licenser,
          :process_locker,
          :packer,
          :vagrant])
  end
end
