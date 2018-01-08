# rubocop:disable Style/FileName
# frozen_string_literal: true
# rubocop:enable Style/FileName

# Copyright (C) 2017 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

$LOAD_PATH.unshift(__dir__)

mode = (ENV['PROJECT_MODE'] || 'development').to_sym
locked = proc do
  Dir.chdir("#{__dir__}/..") do
    [['gems.rb', 'gems.locked'], ['Gemfile', 'Gemfile.lock']]
      .map { |m| Dir.glob(m).size >= 2 }
      .include?(true)
  end
end.call

if locked
  require 'rubygems'
  require 'bundler/setup'
  require 'bootsnap'

  Bootsnap.setup(
    cache_dir:            '.boot',
    development_mode:     :development == mode,
    load_path_cache:      true,
    autoload_paths_cache: true,
    disable_trace:        true,
    compile_cache_iseq:   true,
    compile_cache_yaml:   true
  )
end

if locked and :development == mode
  require 'swag_dev/project/pp'
end

require File.basename(__FILE__, '.rb').tr('-', '/')
