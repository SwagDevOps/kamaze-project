# frozen_string_literal: true

require 'kamaze/project/version'

describe Kamaze::Project::Version, :version do
  # class methods
  it do
    expect(described_class).to respond_to(:new).with(0).arguments
    expect(described_class).to respond_to(:new).with(1).arguments
  end

  # instance methods
  it do
    expect(subject).to respond_to('valid?').with(0).arguments
    expect(subject).to respond_to('to_h').with(0).arguments
    expect(subject).to respond_to('to_path').with(0).arguments
  end
end

# testing using current context
describe Kamaze::Project::Version, :version do
  context '#load_file' do
    it { expect(subject.__send__(:load_file)).to be_a(Hash) }
  end

  context '#to_path' do
    it { expect(subject.to_path).to be_a(String) }
  end

  context '#to_s' do
    it { expect(subject.to_s).to match(/^([0-9]+\.){2}[0-9]+$/) }
  end

  context '#valid?' do
    it { expect(subject.valid?).to be(true) }
  end

  context '.file_name' do
    it { expect(described_class.__send__(:file_name)).to be_a(Pathname) }
  end

  context '.file_name.file?' do
    it { expect(described_class.__send__(:file_name).file?).to be(true) }
  end
end
