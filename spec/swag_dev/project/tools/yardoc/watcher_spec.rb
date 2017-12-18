# frozen_string_literal: true

require 'swag_dev/project/tools/yardoc/watcher'

describe SwagDev::Project::Tools::Yardoc::Watcher do
  build('project/tools/yardoc/watcher')
    .describe_instance_methods
    .each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end
end
