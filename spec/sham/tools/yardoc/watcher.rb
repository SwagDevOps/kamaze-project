# frozen_string_literal: true

require 'securerandom'

Sham.config(FactoryStruct, :'tools/yardoc/watcher') do |c|
  c.attributes do
    {
      paths_randomizer: lambda do
        Array.new(Random.new.rand(2...10)).map { SecureRandom.hex[0..8] }
      end,
      patterns_randomizer: lambda do
        Array.new(Random.new.rand(2...10)).map { SecureRandom.hex[0..8] }
      end,
      options_randomizer: lambda do
        {
          only: Regexp.new(Array.new(Random.new.rand(2...10)).map do
                             '\.%s$' % SecureRandom.hex[0..2]
                           end.join('|')),
          ignore: Regexp.new(Array.new(Random.new.rand(2...10)).map do
                               '%s/' % SecureRandom.hex[0..6]
                             end.join('|'))
        }
      end
    }
  end
end
