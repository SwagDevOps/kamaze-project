# frozen_string_literal: true

require 'swag_dev/project/concern/cli'

FactoryBot.define do
  factory 'concern/cli', class: FactoryStruct do
    sequence(:subject) do |seq|
      @subjects ||= []

      @subjects[seq] = Class.new do
        include SwagDev::Project::Concern::Cli
      end.new
    end
  end
end
