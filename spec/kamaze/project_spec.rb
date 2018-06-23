# frozen_string_literal: true

require 'kamaze/project'

# testing instance (methods)
describe Kamaze::Project, :project do
  let(:subject) { Kamaze.project }

  it { expect(subject).to respond_to(:name).with(0).arguments }
  it { expect(subject).to respond_to(:subject).with(0).arguments }
  it { expect(subject).to respond_to(:version).with(0).arguments }
  it { expect(subject).to respond_to('load!').with(0).arguments }
  it { expect(subject).to respond_to(:mode).with(0).arguments }
  it { expect(subject).to respond_to(:tasks).with(0).arguments }
  it { expect(subject).to respond_to(:tools).with(0).arguments }

  it { expect(subject).to respond_to(:path).with(0).arguments }
  it { expect(subject).to respond_to(:path).with_unlimited_arguments }
  it { expect(subject.class).to define_constant(:VERSION) }
end
