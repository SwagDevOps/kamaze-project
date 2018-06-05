# frozen_string_literal: true

require 'kamaze/project/concern/cli'

describe Class, :concern, :'concern/cli' do
  let(:subject) { sham!('concern/cli').subjecter.call }

  it { expect(subject).to respond_to(:successful?).with(0).arguments }
  it { expect(subject).to respond_to(:success?).with(0).arguments }
  it { expect(subject).to respond_to(:failed?).with(0).arguments }
  it { expect(subject).to respond_to(:failure?).with(0).arguments }
end

# Build an instance of ``cli`` with a retcode ``255``
describe Class, :concern, :'concern/cli' do
  let(:subject) do
    sham!('concern/cli').subjecter.call.tap do |subject|
      subject.__send__('retcode=', 255)
    end
  end

  context '#success?' do
    it { expect(subject.success?).to be(false) }
  end

  context '#failure?' do
    it { expect(subject.failure?).to be(true) }
  end

  context '#retcode' do
    it { expect(subject.retcode).to be(255) }
  end
end

# Build an instance of ``cli`` with default retcode
describe Class, :concern, :'concern/cli' do
  let(:subject) { sham!('concern/cli').subjecter.call }

  context '#success?' do
    it { expect(subject.success?).to be(true) }
  end

  context '#failure?' do
    it { expect(subject.failure?).to be(false) }
  end

  context '#retcode' do
    it { expect(subject.retcode).to be(Errno::NOERROR::Errno) }
  end
end
