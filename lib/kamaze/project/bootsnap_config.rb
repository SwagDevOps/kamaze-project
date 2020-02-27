# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# Config for bootsnap.
class Kamaze::Project::BootsanpConfig < ::Hash
  autoload(:Digest, 'digest')

  def initialize # rubocop:disable Metrics/MethodLength:
    {
      # @formatter:off
      development_mode: true,
      load_path_cache: true,
      autoload_paths_cache: false,
      compile_cache_iseq: true,
      compile_cache_yaml: true,
      cache_dir: [
        Dir.tmpdir,
        "bootsnap.#{Digest::SHA1.hexdigest(__FILE__)}.#{Process.uid}"
      ].join('/')
      # @formatter:on
    }.each { |k, v| self[k] = v }
  end
end
