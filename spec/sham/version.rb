# frozen_string_literal: true

require 'securerandom'

# Return samples as a Hash with files indexed by name
sampler = lambda do
  {}.yield_self do |samples|
    Dir.glob(SAMPLES_PATH.join('version', '*.yml')).each do |file|
      file = Pathname.new(file)
      name = file.basename('.yml')

      samples[name.to_s] = file.freeze
    end

    # add random (inexisting file)
    samples['random'] = Array.new(3).yield_self do |parts|
      parts.map! { |t| SecureRandom.hex[0..8] }

      parts.join('/').concat('.yml')
    end

    samples
  end
end

Sham.config(FactoryStruct, File.basename(__FILE__, '.*').to_sym) do |c|
  c.attributes do
    {
      samples: sampler.call
    }
  end
end
