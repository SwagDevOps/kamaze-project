# rubocop:disable Naming/FileName
# frozen_string_literal: true
# rubocop:enable Naming/FileName

# Copyright (C) 2017 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

$LOAD_PATH.unshift(__dir__)

mode = (ENV['PROJECT_MODE'] || 'development').to_sym
lock = Dir.chdir("#{__dir__}/..") do
  [['gems.rb', 'gems.locked'], ['Gemfile', 'Gemfile.lock']]
    .map { |m| Dir.glob(m).size >= 2 }
    .include?(true)
end

if lock
  require 'rubygems'
  require 'bundler/setup'

  if :development == mode
    require 'bootsnap'

    Bootsnap.setup(
      cache_dir:            "#{__dir__}/../cache",
      development_mode:     true,
      load_path_cache:      true,
      autoload_paths_cache: false,
      disable_trace:        true,
      compile_cache_iseq:   true,
      compile_cache_yaml:   true
    )
  end
end
