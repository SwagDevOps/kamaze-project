# frozen_string_literal: true

require 'kamaze/project'

# testing ``Kamaze.project`` method
describe Kamaze, :project do
  it { expect(described_class).to respond_to(:project).with(0).arguments }

  context '.project' do
    let(:subject) { Kamaze.project }

    it { expect(described_class.project).to be_a(subject.class) }
  end
end
