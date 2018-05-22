# frozen_string_literal: true

# Return samples as a Hash with files indexed by name
sampler = lambda do
  {}.yield_self do |samples|
    Dir.glob(SAMPLES_PATH.join('version', '*.yml')).each do |file|
      file = Pathname.new(file)
      name = file.basename('.yml')

      samples[name.to_s] = file.freeze
    end

    samples
  end
end

FactoryBot.define do
  factory 'version', class: FactoryStruct do
    samples(sampler.call)
  end
end
