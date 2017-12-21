# frozen_string_literal: true

require 'swag_dev/project/tools/console'

describe SwagDev::Project::Tools::Console do
  build('tools/console')
    .describe_instance_methods
    .each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end

  context '.new' do
    it do
      base_class = SwagDev::Project::Tools::BaseTool

      expect(described_class.new).to be_a(base_class)
    end
  end
end

describe SwagDev::Project::Tools::Console do
  context '#mutable_attributes' do
    [:stdout, :stderr].each do |attr|
      it { expect(subject.mutable_attributes).to include(attr) }
    end
  end

  [:stdout, :stderr].each do |attr|
    context "##{attr}" do
      it do
        output_class = SwagDev::Project::Tools::Console::Output

        expect(subject.public_send(attr)).to be_a(output_class)
      end
    end
  end
end
