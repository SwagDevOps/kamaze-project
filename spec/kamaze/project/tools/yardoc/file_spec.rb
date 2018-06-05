# frozen_string_literal: true

require 'kamaze/project/tools/yardoc/file'
require 'pathname'

describe Kamaze::Project::Tools::Yardoc::File, \
         :tools, :'tools/yardoc', :'tools/yardoc/file' do
  subject { described_class.new('sample.ext', false) }

  it { expect(subject).to respond_to(:paths).with(0).arguments }
  it { expect(subject).to respond_to(:to_a).with(0).arguments }
  it { expect(subject).to respond_to(:glob?).with(0).arguments }
end
