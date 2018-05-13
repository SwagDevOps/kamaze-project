# frozen_string_literal: true

require 'kamaze/project/concern/observable'

FactoryBot.define do
  factory 'concern/observable', class: FactoryStruct do
    sequence(:described_class) do |seq|
      @described_classes ||= []

      @described_classes[seq] = Class.new do
        include Kamaze::Project::Concern::Observable
      end
    end
  end
end
