# frozen_string_literal: true

require 'kamaze/project/tools/console/output'
require 'stringio'

describe Kamaze::Project::Tools::Console::Output, \
         :tools, :'tools/console', :'tools/console/output' do
  it { expect(subject).to respond_to('tty?').with(0).arguments }
  it { expect(subject).to respond_to(:flush).with(0).arguments }
  it { expect(subject).to respond_to(:print).with(0).arguments }
  it { expect(subject).to respond_to(:print).with(1).arguments }
  it { expect(subject).to respond_to(:puts).with(0).arguments }
  it { expect(subject).to respond_to(:puts).with(1).arguments }
  it { expect(subject).to respond_to(:write).with(1).arguments }

  context '.new' do
    [File.open(File::NULL, 'w'), StringIO.new].each do |stream|
      it { expect(described_class.new(stream)).to be_a(described_class) }
    end
  end
end
