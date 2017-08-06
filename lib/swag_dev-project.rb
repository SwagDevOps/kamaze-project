# rubocop:disable Style/FileName
# frozen_string_literal: true
# rubocop:enable Style/FileName

# Copyright (C) 2017 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

if File.file?("#{__dir__}/../Gemfile.lock")
  require 'rubygems'
  require 'bundler'

  Bundler.setup(:default)
end

$LOAD_PATH.unshift __dir__

if File.file?("#{__dir__}/../Gemfile.lock")
  if 'development' == ENV['PROJECT_MODE']
    require 'bundler/setup'

    def pp(*args)
      proc do
        require 'active_support/inflector'
        require 'swag_dev/project/helper/debug'

        ActiveSupport::Inflector.constantize('SwagDev::Project::Helper::Debug')
      end.call.new.dump(*args)
    end
  end
end

require File.basename(__FILE__, '.rb').tr('-', '/')
