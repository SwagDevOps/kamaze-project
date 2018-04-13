# frozen_string_literal: true

require 'securerandom'

random_tools = lambda do |times = 10|
  Array.new(times).map do |i|
    srnd = SecureRandom.hex[0..8]
    name = 'tool_%<rand>s' % { rand: srnd }

    klass = Object.const_set("Tool#{srnd}", Class.new).tap do |c|
      c.__send__(:define_method, :random_name, -> { name })
    end

    [name, klass]
  end.to_h
end

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

    # sequences usable during initialization
    #
    # 'paths=', 'options=', 'patterns='
    sequence(:random_tools) do |seq|
      @random_tools ||= []
      @random_tools[seq] ||= random_tools.call
    end
  end
end
