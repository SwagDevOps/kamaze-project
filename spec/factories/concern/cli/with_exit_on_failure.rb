# frozen_string_literal: true

require 'kamaze/project/concern/cli/with_exit_on_failure'

FactoryBot.define do
  factory 'concern/cli/with_exit_on_failure', class: FactoryStruct do
    sequence(:subject) do |seq|
      @subjects ||= []

      @subjects[seq] = Class.new do
        # include Kamaze::Project::Concern::Env
      end.new
    end
  end
end
