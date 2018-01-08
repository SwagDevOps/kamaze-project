# frozen_string_literal: true

require 'swag_dev/project/helper'
require 'swag_dev/project/helper/inflector'

# testing instance
describe SwagDev::Project::Helper, :helper do
  let(:subject) do
    described_class.__send__(:new)
  end

  context '#to_h' do
    it { expect(subject.__send__(:to_h)).to be_a(Hash) }
  end

  context '#to_h.keys' do
    it { expect(subject.__send__(:to_h).keys).to eq([:inflector]) }
  end

  # getting inflector
  context '#get' do
    it do
      klass = SwagDev::Project::Helper::Inflector

      expect(subject.get(:inflector)).to be_a(klass)
    end
  end
end
