# frozen_string_literal: true

require 'swag_dev/project/tools'

describe SwagDev::Project::Tools::BaseTool do
  build('project/tools/base_tool')
    .describe_instance_methods
    .each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end
end

describe SwagDev::Project::Tools::BaseTool do
  context '#mutable_attributes' do
    it { expect(subject.mutable_attributes).to be_a(Array) }

    it { expect(subject.mutable_attributes).to eq([]) }
  end
end
