# frozen_string_literal: true

require 'kamaze/project/tools/yardoc/watcher'

describe Kamaze::Project::Tools::Yardoc::Watcher, \
         :tools, :'tools/yardoc', :'tools/yardoc/watcher' do
  build('tools/yardoc/watcher')
    .describe_instance_methods
    .each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end
end

# rubocop:disable Metrics/BlockLength
10.times do
  describe Kamaze::Project::Tools::Yardoc::Watcher, \
           :tools, :'tools/yardoc', :'tools/yardoc/watcher' do
    let(:paths) { build('tools/yardoc/watcher').random_paths }
    let(:patterns) { build('tools/yardoc/watcher').random_patterns }
    let(:options) { build('tools/yardoc/watcher').random_options }

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
