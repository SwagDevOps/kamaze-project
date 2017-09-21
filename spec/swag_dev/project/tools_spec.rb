# frozen_string_literal: true

require 'swag_dev/project/tools'

describe SwagDev::Project::Tools do
  # instance methods
  {
    to_h: [0],
    get: [1],
    fetch: [1],
    '[]': [1],
    'member?' => [1]
  }.each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end
end
