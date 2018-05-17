# frozen_string_literal: true

# rubocop:disable Style/MultilineIfModifier
describe Object, :core_ext, :'core_ext/object', :pp, :development do
  let(:subject) do
    # ``pp`` method SHOULD be ``private``
    subject = described_class.new
    subject.singleton_class.class_eval { public 'pp' }

    subject
  end

  it { expect(subject).to respond_to(:pp) }
  it { expect(subject).to respond_to(:pp).with(0).arguments }
  it { expect(subject).to respond_to(:pp).with_unlimited_arguments }

  # testing return type and value(s)
  {
    [] => nil.class,
    [{}] => Hash,
    [42] => Integer,
    [42, 1337] => Array
  }.each do |params, type|
    context ".pp(*#{params})" do
      before { allow($stdout).to receive(:write) }

      it { expect(subject.pp(*params)).to be_a(type) }

      it do
        expect(subject.pp(*params))
          .to eq(params.size <= 1 ? params[0] : params)
      end
    end
  end
end if :development == ENV['PROJECT_MODE']&.to_sym
# rubocop:enable Style/MultilineIfModifier
