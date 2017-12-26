# frozen_string_literal: true
# rubocop:disable Style/FileName

# Copyright (C) 2017 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

locked = proc do
  Dir.chdir("#{__dir__}/..") do
    gemfiles = ['gems.rb', 'gems.locked', 'Gemfile', 'Gemfile.lock']

    Dir.glob(gemfiles).size >= 2
  end
end.call

if locked
  require 'rubygems'
  require 'bundler'

  Bundler.setup(:default)
end

$LOAD_PATH.unshift __dir__

if locked and 'development' == ENV['PROJECT_MODE']
  require 'bundler/setup'

  def pp(*args)
    proc do
      require 'active_support/inflector'
      require 'swag_dev/project/helper/debug'

      ActiveSupport::Inflector.constantize('SwagDev::Project::Helper::Debug')
    end.call.new.dump(*args)
  end
end

require File.basename(__FILE__, '.rb').tr('-', '/')
# rubocop:enable Style/FileName
