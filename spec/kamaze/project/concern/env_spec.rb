# frozen_string_literal: true

require 'kamaze/project/concern/env'

# Ensure attr_accessor is accessible
describe Class, :concern, :'concern/env' do
  subject { build('concern/env').subject }

  it { expect(subject).to respond_to(:env_loaded) }

  context '#env_loaded' do
    it do
      expect(subject.env_loaded).to be_a(Hash)
      expect(subject.env_loaded).to be_empty
    end
  end
end

# Use #env_loaded (protected)
describe Class, :concern, :'concern/env' do
  context '#env_loaded' do
    let(:env) do
      { 'FOO' => 'bar', 'PI' => Math::PI.to_s }
    end

    let(:subject) do
      build('concern/env')
        .subject
        .tap { |subject| subject.__send__(:'env_loaded=', env) }
    end

    it do
      expect(subject.env_loaded).to be_a(Hash)
      expect(subject.env_loaded).to eq(env)
    end
  end
end

# Load a sample file (math.env)
describe Class, :concern, :'concern/env' do
  context '#env_loaded' do
    let(:file) { build('concern/env').files[:math] }

    let(:subject) do
      build('concern/env')
        .subject
        .__send__(:env_load,
                  pwd: file.path.dirname,
                  file: file.path.basename)
    end

    it do
      expect(subject.env_loaded).to be_a(Hash)
      expect(subject.env_loaded).to eq(file.data)
    end
  end
end
