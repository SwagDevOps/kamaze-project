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

    subject do
      described_class.new do |watcher|
        watcher.paths = paths
      end
    end

    context '#paths' do
      it { expect(subject.paths).to eq(paths) }
    end
  end
end
