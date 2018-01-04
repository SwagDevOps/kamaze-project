# frozen_string_literal: true

env = ENV['PROJECT_MODE'] || 'development'

if 'development' == env
  describe Object do
    [1, 2, 3].each do |n|
      it { expect(subject).to respond_to(:pp).with(n).arguments }
    end
  end
end
