# frozen_string_literal: true

require 'kamaze/project/concern/observable'

describe Class, :concern, :'concern/observable' do
  let(:described_class) { sham!('concern/observable').subjecter.call.class }

  it do
    expect(described_class).to respond_to(:add_observer)
    expect(described_class).to respond_to(:add_observer).with(1).arguments
    expect(described_class).to respond_to(:add_observer).with(2).arguments
  end

  it do
    expect(described_class).to respond_to(:delete_observer)
    expect(described_class).to respond_to(:delete_observer).with(1).arguments
  end

  it do
    expect(described_class).to respond_to(:delete_observers)
    expect(described_class).to respond_to(:delete_observers).with(0).arguments
  end

  it do
    expect(described_class.protected_methods).to include(:observer_peers)
  end
end

describe Class, :concern, :'concern/observable' do
  context '.protected_methods' do
    subject { sham!('concern/observable').subjecter.call }

    [:dispatch_event,
     :observer_peers,
     :observer_peers_initialize].each do |func|
      it { expect(subject.protected_methods).to include(func) }
    end
  end

  context '.observer_peers' do
    subject { sham!('concern/observable').subjecter.call }

    it { expect(subject.__send__(:observer_peers)).to be_a(Hash) }
  end
end
