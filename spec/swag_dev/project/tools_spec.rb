# frozen_string_literal: true

require 'swag_dev/project/tools'

describe SwagDev::Project::Tools, :tools do
  build('tools')
    .describe_instance_methods
    .each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end
end

describe SwagDev::Project::Tools, :tools do
  context '.defaults' do
    # rubocop:disable Performance/HashEachMethods
    build('tools').keys.each do |k|
      it { expect(described_class.defaults.keys).to include(k) }
    end
    # rubocop:enable Performance/HashEachMethods
  end

  context '#to_h' do
    it { expect(subject.to_h).to be_a(Hash) }
  end

  context '#to_h.keys' do
    # rubocop:disable Performance/HashEachMethods
    build('tools').keys.each do |k|
      it { expect(subject.to_h.keys).to include(k) }
    end
    # rubocop:enable Performance/HashEachMethods
  end
end
