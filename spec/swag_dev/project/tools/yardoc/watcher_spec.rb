# frozen_string_literal: true

require 'swag_dev/project/tools/yardoc/watcher'

describe SwagDev::Project::Tools::Yardoc::Watcher do
  build('project/tools/yardoc/watcher')
    .describe_instance_methods
    .each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end
end

10.times do
  describe SwagDev::Project::Tools::Yardoc::Watcher do
    let(:paths) { build('project/tools/yardoc/watcher').random_paths }
    let(:patterns) { build('project/tools/yardoc/watcher').random_patterns }
    let(:options) { build('project/tools/yardoc/watcher').random_options }

    subject do
      described_class.new do |watcher|
        watcher.paths = paths
        watcher.patterns = patterns
        watcher.options = options
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
