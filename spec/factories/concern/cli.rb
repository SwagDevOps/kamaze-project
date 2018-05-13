# frozen_string_literal: true

require 'kamaze/project/concern/cli'

FactoryBot.define do
  factory 'concern/cli', class: FactoryStruct do
    sequence(:subject) do |seq|
      @subjects ||= []

      @subjects[seq] = Class.new do
        include Kamaze::Project::Concern::Cli
      end.new
    end
  end
end
