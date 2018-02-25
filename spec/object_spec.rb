# frozen_string_literal: true

env = ENV['PROJECT_MODE'] || 'development'

if 'development' == env
  describe Object, :core_ext, :'core_ext/object', :development do
    let(:subject) do
      # ``pp`` method SHOULD be ``private``
      subject = described_class.new
      subject.singleton_class.class_eval { public 'pp' }

      subject
    end

    it { expect(subject).to respond_to(:pp) }
    it { expect(subject).to respond_to(:pp).with(0).arguments }
    it { expect(subject).to respond_to(:pp).with_unlimited_arguments }
  end
end
