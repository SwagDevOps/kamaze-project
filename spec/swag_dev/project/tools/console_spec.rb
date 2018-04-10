# frozen_string_literal: true

require 'swag_dev/project/tools/console'

describe SwagDev::Project::Tools::Console, :tools, :'tools/console' do
  context '.new' do
    it do
      base_class = SwagDev::Project::Tools::BaseTool

      expect(described_class.new).to be_a(base_class)
    end
  end
end

describe SwagDev::Project::Tools::Console, :tools, :'tools/console' do
  [:stdout, :stderr].each do |attr|
    it { expect(subject).to respond_to(attr).with(0).arguments }

    context '#mutable_attributes' do
      it { expect(subject.mutable_attributes).to include(attr) }
    end

    context "##{attr}" do
      it do
        output_class = SwagDev::Project::Tools::Console::Output

        expect(subject.public_send(attr)).to be_a(output_class)
      end
    end
  end
end
