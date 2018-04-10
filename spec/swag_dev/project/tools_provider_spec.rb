# frozen_string_literal: true

require 'swag_dev/project/tools_provider'

describe SwagDev::Project::ToolsProvider, :tools_provider do
  it { expect(described_class).to respond_to(:defaults).with(0).arguments }

  it { expect(subject).to respond_to(:to_h).with(0).arguments }
  it { expect(subject).to respond_to(:get).with(1).arguments }
  it { expect(subject).to respond_to(:fetch).with(1).arguments }
  it { expect(subject).to respond_to('[]').with(1).arguments }
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
end
