# frozen_string_literal: true

require 'kamaze/project/concern'

# Files are described by path and data (content loaded as env)
sample_files = {
  math: {
    path: SAMPLES_PATH.join('concern/env/math.env').realpath,
    data: {
      'MATH_E' => Math::E.to_s,
      'MATH_PI' => Math::PI.to_s
    }
  }
}

Sham.config(FactoryStruct, :'concern/env') do |c|
  c.attributes do
    {
      subjecter: lambda do
        Class.new { include Kamaze::Project::Concern::Env }.new
      end,
      files: sample_files.map { |k, v| [k, FactoryStruct.new(v)] }.to_h,
    }
  end
end
