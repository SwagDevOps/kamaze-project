# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

{
  pp: proc { ENV['PROJECT_MODE'] == 'development' },
  object: proc { true },
}.each do |requirement, conditionner|
  next unless conditionner.call

  require_relative "../core_ext/#{requirement}"
end
