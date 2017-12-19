# frozen_string_literal: true

require 'swag_dev/project/tools/yardoc/file'
require 'pathname'

describe SwagDev::Project::Tools::Yardoc::File do
  subject { described_class.new('sample.ext', false) }

  build('tools/yardoc/file')
    .describe_instance_methods
    .each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end
end
