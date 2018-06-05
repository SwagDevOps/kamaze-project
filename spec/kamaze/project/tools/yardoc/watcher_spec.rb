# frozen_string_literal: true

require 'kamaze/project/tools/yardoc/watcher'

describe Kamaze::Project::Tools::Yardoc::Watcher, \
         :tools, :'tools/yardoc', :'tools/yardoc/watcher' do
  it { expect(subject).to respond_to(:paths).with(0).arguments }
  it { expect(subject).to respond_to(:options).with(0).arguments }
  it { expect(subject).to respond_to(:patterns).with(0).arguments }

  it { expect(subject).to respond_to(:watch).with(0).arguments }
  it { expect(subject).to respond_to(:watch).with(1).arguments }
end

# rubocop:disable Metrics/BlockLength
10.times do
  describe Kamaze::Project::Tools::Yardoc::Watcher, \
           :tools, :'tools/yardoc', :'tools/yardoc/watcher' do
    let(:paths) { sham!('tools/yardoc/watcher').paths_randomizer.call }
    let(:patterns) { sham!('tools/yardoc/watcher').patterns_randomizer.call }
    let(:options) { sham!('tools/yardoc/watcher').options_randomizer.call }

    subject do
      # testing purpose only, SHOULD use an observer instead
      described_class.new.yield_self do |watcher|
        {
          paths: paths,
          patterns: patterns,
          options: options
        }.each { |k, v| watcher.__send__("#{k}=", v) }

        watcher
      end
    end

    context '#paths' do
      it { expect(subject.paths).to eq(paths) }
      it { expect(subject.paths).to be_kind_of(Array) }
    end

    context '#patterns' do
      it { expect(subject.patterns).to eq(patterns) }
      it { expect(subject.patterns).to be_kind_of(Array) }
    end

    context '#options' do
      it { expect(subject.options).to eq(options) }
      it { expect(subject.options).to be_kind_of(Hash) }
    end
  end
end
# rubocop:enable Metrics/BlockLength
