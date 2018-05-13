# frozen_string_literal: true

{
  pp: proc { ENV['PROJECT_MODE'] == 'development' },
  object: proc { true },
}.each do |requirement, conditionner|
  next unless conditionner.call

  require_relative "../core_ext/#{requirement}"
end
