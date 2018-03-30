# frozen_string_literal: true

require 'swag_dev/project/concern/observable'

FactoryBot.define do
  factory 'concern/observable', class: FactoryStruct do
    sequence(:described_class) do |seq|
      @described_classes ||= []

      @described_classes[seq] = Class.new do
        include SwagDev::Project::Concern::Observable
      end
    end
  end
end
