# frozen_string_literal: true

require 'kamaze/project/tools/base_tool'

describe Kamaze::Project::Tools::BaseTool, :tools, :'tools/base_tool' do
  it { expect(subject).to respond_to(:mutable_attributes).with(0).arguments }

  context '#mutable_attributes' do
    it { expect(subject.mutable_attributes).to be_a(Array) }

    it { expect(subject.mutable_attributes).to eq([]) }
  end

  # protected --------------------------------------------------------

  # setup method is provided for inheritance
  # this method is used during instance initialization
  context '#setup' do
    it { expect(subject.__send__(:setup)).to be_nil }
  end

  context '#attrs_mute!' do
    it { expect(subject.__send__('attrs_mute!')).to be(subject) }
  end
end
