# frozen_string_literal: true

require 'securerandom'
require 'swag_dev/project/tools'
require 'swag_dev/project/tools_provider'

describe SwagDev::Project::ToolsProvider, :tools_provider do
  it { expect(described_class).to respond_to(:defaults).with(0).arguments }

  it { expect(subject).to respond_to(:to_h).with(0).arguments }
  it { expect(subject).to respond_to(:get).with(1).arguments }
  it { expect(subject).to respond_to(:fetch).with(1).arguments }
  it { expect(subject).to respond_to('[]').with(1).arguments }
  it { expect(subject).to respond_to('[]=').with(2).arguments }
  it { expect(subject).to respond_to('member?').with(1).arguments }
  it { expect(subject).to respond_to('merge!').with(1).arguments }
end

describe SwagDev::Project::ToolsProvider, :tools_provider do
  context '.defaults' do
    build('tools').keys.each do |k|
      it { expect(described_class.defaults.keys).to include(k) }
    end
  end

  context '#to_h' do
    it { expect(subject.to_h).to be_a(Hash) }
  end

  context '#to_h.keys' do
    build('tools').keys.each do |k|
      it { expect(subject.to_h.keys).to include(k) }
    end
  end

  build('tools').keys.each do |k|
    context "#to_h[#{k}]" do
      it do
        # SHOULD receive ``BaseTool`` instances
        expect(subject.to_h[k]).not_to be_a(String)
        expect(subject.to_h[k]).to be_a(SwagDev::Project::Tools::BaseTool)
      end
    end
  end
end

describe SwagDev::Project::ToolsProvider, :tools_provider do
  context '#[]' do
    it { expect(subject["fake_#{SecureRandom.hex[0..8]}"]).to be(nil) }
  end

  context '#fetch()' do
    it do
      expect { subject.fetch("fake_#{SecureRandom.hex[0..8]}") }
        .to raise_error(KeyError)
    end

    build('tools').keys.shuffle.each do |k|
      it do
        # use ``to_h`` method before a ``fetch``
        tool = subject.to_h[k]

        expect(subject.fetch(k)).to be_a(tool.class)
      end
    end
  end
end

# Provide, not so evident, proofs of success for ``merge!``
describe SwagDev::Project::ToolsProvider, :tools_provider do
  context '#merge!.fetch(k)' do
    let(:random_tools) { build('tools').random_tools }

    it do
      subject.merge!(random_tools)

      random_tools.each do |k, v|
        expect(subject.fetch(k)).to be_a(v)
        expect(subject.fetch(k)).to respond_to(:random_name)
      end
    end
  end

  context '#merge!.fetch(k).random_name' do
    let(:random_tools) { build('tools').random_tools }

    it do
      subject.merge!(random_tools)

      random_tools.each do |k, v|
        expect(subject.fetch(k).random_name).to eq(k.to_s)
      end
    end
  end
end

describe SwagDev::Project::ToolsProvider, :tools_provider do
  let(:random_tools) { build('tools').random_tools }
  let(:target) { build('tools').keys[0] }
  let(:replacement) { random_tools.to_a[0][1] }

  # replace an original tool by an arbitrary class
  context '.fetch(k).class' do
    it do
      subject[target] = replacement

      expect(subject.fetch(target).class).to eq(replacement)
    end
  end
end
