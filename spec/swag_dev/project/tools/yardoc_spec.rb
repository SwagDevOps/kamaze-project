# frozen_string_literal: true

require 'swag_dev/project/tools/yardoc'

describe SwagDev::Project::Tools::Yardoc do
  build('project/tools/yardoc')
    .describe_instance_methods
    .each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end
end
