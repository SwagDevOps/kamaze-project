# frozen_string_literal: true

require 'swag_dev/project/tools/base_tool'

describe SwagDev::Project::Tools::BaseTool, :tools, :'tools/base_tools' do
  it { expect(subject).to respond_to(:mutable_attributes).with(0).arguments }

  context '#mutable_attributes' do
    it { expect(subject.mutable_attributes).to be_a(Array) }

    it { expect(subject.mutable_attributes).to eq([]) }
  end

  # setup method is provided for inheritance
  # this method is used during instance initialization
  context '#setup' do
    it { expect(subject.__send__(:setup)).to be_nil }
  end
end
