# frozen_string_literal: true

require 'securerandom'

# Return tools as a Hash with Class(es) indexed by string
randomizer = lambda do |times = 10|
  Array.new(times).map do |i|
    srnd = SecureRandom.hex[0..8]
    name = 'tool_%<rand>s' % { rand: srnd }

    klass = Object.const_set("Tool#{srnd}", Class.new).tap do |c|
      c.__send__(:define_method, :random_name, -> { name })
    end

    [name, klass]
  end.to_h
end

Sham.config(FactoryStruct, File.basename(__FILE__, '.*').to_sym) do |c|
  c.attributes do
    {
      randomizer: randomizer,
      faker: -> { "fake_#{SecureRandom.hex[0..8]}" },
      keys: [:console,
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
             :yardoc_watcher].shuffle,
    }
  end
end
