# frozen_string_literal: true

require 'swag_dev/project/tools/yardoc'
require 'pathname'

describe SwagDev::Project::Tools::Yardoc do
  build('project/tools/yardoc')
    .describe_instance_methods
    .each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end

  it { expect(subject).to be_a(SwagDev::Project::Tools::BaseTool) }
end

describe SwagDev::Project::Tools::Yardoc do
  context '#mutable_attributes' do
    it { expect(subject.mutable_attributes).to be_empty }
  end

  context '#output_dir' do
    it { expect(subject.output_dir).to be_a(Pathname) }
    it { expect(subject.output_dir).to eq(Pathname.new('doc')) }
  end

  context '#excluded' do
    it { expect(subject.excluded).to be_a(Array) }
  end

  context '#options' do
    it { expect(subject.options).to be_a(Hash) }
  end

  context '#paths' do
    it { expect(subject.paths).to be_a(Array) }
    it { expect(subject.paths).to eq([Pathname.new('lib')]) }
  end
end
