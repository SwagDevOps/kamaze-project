# frozen_string_literal: true

require 'swag_dev/project/concern/env'

describe Class, :concern, :'concern/env' do
  subject do
    described_class.new do
      include SwagDev::Project::Concern::Env
    end.new
  end

  it { expect(subject).to respond_to(:env_loaded) }

  context '#env_loaded' do
    it do
      expect(subject.env_loaded).to be_a(Hash)
      expect(subject.env_loaded).to be_empty
    end
  end

  context '#env_loaded' do
    let(:env) do
      { 'FOO' => 'bar', 'PI' => Math::PI.to_s }
    end

    let(:subject_loaded) do
      subject.clone.tap { |subject| subject.__send__(:'env_loaded=', env) }
    end

    it do
      expect(subject_loaded.env_loaded).to be_a(Hash)
      expect(subject_loaded.env_loaded).to eq(env)
    end
  end
end
