# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
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
      @random_tools[seq] ||= {}

      10.times do |t|
        srnd = SecureRandom.hex[0..8]
        name = 'tool_%<rand>s' % { rand: srnd }

        @random_tools[seq][name] = Object.const_set("Tool#{srnd}", Class.new)
        @random_tools[seq][name]
          .__send__(:define_method, :random_name, -> { name })
      end

      @random_tools[seq]
    end
  end
end
# rubocop:enable Metrics/BlockLength
