# frozen_string_literal: true

require 'kamaze/project/concern'

# Files are described by path and data (content loaded as env)
sample_files = {
  math: [
    SAMPLES_PATH.join('concern/env/math.env').realpath,
    {
      'MATH_E' => Math::E.to_s,
      'MATH_PI' => Math::PI.to_s
    }
  ]
}

FactoryBot.define do
  factory 'concern/env', class: FactoryStruct do
    sequence(:subject) do |seq|
      @subjects ||= []

      @subjects[seq] = Class.new do
        include Kamaze::Project::Concern::Env
      end.new
    end

    sequence(:files) do |seq|
      @files ||= []

      sample_files.each do |k, v|
        @files
          .tap { |h| h[seq] = {} } [seq]
          .merge!(k => FactoryStruct.new(path: v.fetch(0), data: v.fetch(1)))
      end

      @files[seq]
    end
  end
end
