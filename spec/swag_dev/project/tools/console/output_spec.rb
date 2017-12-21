# frozen_string_literal: true

require 'swag_dev/project/tools/console/output'
require 'stringio'

describe SwagDev::Project::Tools::Console::Output do
  build('tools/console/output')
    .describe_instance_methods
    .each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end

  context '.new' do
    [File.open(File::NULL, 'w'), StringIO.new].each do |stream|
      it { expect(described_class.new(stream)).to be_a(described_class) }
    end
  end
end
