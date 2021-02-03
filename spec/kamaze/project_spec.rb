# frozen_string_literal: true

require 'kamaze/project'

# constants ---------------------------------------------------------
describe Kamaze::Project, :project do
  [
    :VERSION,
    :Bundled,
    :Concern,
    :Config,
    :Debug,
    :DSL,
    :Helper,
    :Inflector,
    :Observable,
    :Observer,
    :Struct,
    :Tools,
    :ToolsProvider,
  ].each do |sym|
    it { expect(described_class).to define_constant(sym) }
  end
end

# instance methods --------------------------------------------------
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
end
