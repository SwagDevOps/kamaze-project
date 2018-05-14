# frozen_string_literal: true

require 'kamaze/project/tools/yardoc'
require 'pathname'

describe Kamaze::Project::Tools::Yardoc, :tools, :'tools/yardoc' do
  build('tools/yardoc')
    .describe_instance_methods
    .each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end

  it { expect(subject).to be_a(Kamaze::Project::Tools::BaseTool) }
end

describe Kamaze::Project::Tools::Yardoc, :tools, :'tools/yardoc' do
  context '#mutable_attributes' do
    it { expect(subject.mutable_attributes).to eq([:options]) }
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
    it do
      paths = ['.', 'lib'].map { |path| Pathname.new(path) }.sort
      expect(subject.paths).to eq(paths)
    end
  end
end