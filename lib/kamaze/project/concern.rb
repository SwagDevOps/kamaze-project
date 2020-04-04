# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../project'

# Namespace for ``Concern``
module Kamaze::Project::Concern
  # @formatter:off
  {
    Cli: 'cli',
    Env: 'env',
    Helper: 'helper',
    Mode: 'mode',
    Observable: 'observable',
    Sh: 'sh',
    Tasks: 'tasks',
  }.each { |s, fp| autoload(s, "#{__dir__}/concern/#{fp}") }
  # @formatter:on

  [nil, :env, :mode, :helper, :tasks, :tools].each do |req|
    require_relative "./concern/#{req}".gsub(%r{/$}, '')
  end
end
