# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# Config for bootsnap.
class Kamaze::Project::BootsanpConfig < ::Hash
  autoload(:Digest, 'digest')

  def initialize
    {
      # @formatter:off
      development_mode: true,
      load_path_cache: true,
      autoload_paths_cache: false,
      compile_cache_iseq: true,
      compile_cache_yaml: true,
      cache_dir: cache_dir(caller_locations.fetch(0).path)
      # @formatter:on
    }.each { |k, v| self[k] = v }
  end

  protected

  # Get cache dir from given path.
  #
  # @param [String] from_path
  #
  # @return [String]
  def cache_dir(from_path)
    [
      # @formatter:off
      Dir.tmpdir,
      "bootsnap.#{Digest::SHA1.hexdigest(from_path)}.#{Process.uid}",
      # @formatter:on
    ].join('/')
  end
end
