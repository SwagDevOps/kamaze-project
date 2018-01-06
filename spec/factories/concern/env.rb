# -*- coding: utf-8 -*-
# frozen_string_literal: true

FactoryBot.define do
  factory 'concern/env', class: FactoryStruct do
    sequence(:subject) do |seq|
      @subjects ||= []

      @subjects[seq] = Class.new do
        include SwagDev::Project::Concern::Env
      end.new
    end
  end
end
