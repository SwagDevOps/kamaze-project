# frozen_string_literal: true

env = ENV['PROJECT_MODE'] || 'development'

if 'development' == env
  describe Object, :core_ext, :'core_ext/object', :development do
    [1, 2, 3].each do |n|
      it { expect(subject).to respond_to(:pp).with(n).arguments }
    end
  end
end
