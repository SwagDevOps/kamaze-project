# frozen_string_literal: true

require 'kamaze/project/helper'
require 'kamaze/project/helper/inflector'
require 'kamaze/project/helper/project'
require 'kamaze/project/helper/project/config'

# testing instance
describe Kamaze::Project::Helper, :helper do
  let(:subject) { described_class.__send__(:new) }
  let(:helpers) { build('helper').helpers }

  context '#to_h' do
    it { expect(subject.__send__(:to_h)).to be_a(Hash) }
  end

  context '#to_h.keys' do
    it { expect(subject.__send__(:to_h).keys).to eq([:inflector]) }
  end
end

# getting inflector
describe Kamaze::Project::Helper, :helper do
  let(:subject) { described_class.__send__(:new) }
  let(:helpers) { build('helper').helpers }

  context '#get(:inflector)' do
    it { expect(subject.get(:inflector)).to be_a(helpers[:inflector]) }
  end
end

# loading helpers
describe Kamaze::Project::Helper, :helper do
  let(:subject) do
    build('helper').subject.tap do |helper|
      helper.get(:project)
      helper.get('project/config')
    end
  end

  let(:helpers) { build('helper').helpers }

  context '#to_h.keys' do
    it do
      expect(subject.__send__(:to_h).keys.sort).to eq(helpers.keys.sort)
    end
  end
end

describe Kamaze::Project::Helper, :helper do
  let(:subject) { build('helper').subject }

  build('helper').helpers.each do |k, v|
    context "#get(:'#{v}')" do
      it { expect(subject.get(k)).to be_a(v) }
    end
  end
end