# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require 'pathname'

# Filesystem operator (manipulator)
#
# This class is intended to manipulate a ``Filesystem``.
class Kamaze::Project::Tools::Packager::Filesystem::Operator
  autoload(:Pathname, 'pathname')

  # @formatter:off
  {
    Utils: 'utils',
  }.each { |k, v| autoload(k, "#{__dir__}/operator/#{v}") }
  # @formatter:on

  include Utils

  # @return [Kamaze::Project::Tools::Packager::Filesystem]
  attr_reader :fs

  # @param [Kamaze::Project::Tools::Packager::Filesystem] filesystem
  # @param [Hash] options
  # @see fs
  def initialize(filesystem, options = {})
    @fs = filesystem
    @options = { verbose: true }.merge(options.to_h)

    # Pass included methods to protected
    utils_methods.each do |m|
      next unless self.public_methods.include?(m)

      # rubocop:disable Style/AccessModifierDeclarations
      self.singleton_class.class_eval { protected m }
      # rubocop:enable Style/AccessModifierDeclarations
    end
  end

  # Prepare package
  #
  # @return [self]
  def prepare
    fs.package_dirs.each_value { |dir| mkdir_p(dir, **options) }

    self.purge_purgeables.prepare_srcdir
  end

  # Purge purgeables elements
  #
  # @return [self]
  def purge_purgeables
    fs.purgeable_dirs.each_value { |dir| purge(dir, **options) }

    self
  end

  # Prepare ``src`` dir
  #
  # Source files are refreshed (deleted and copied again)
  #
  # @return [self]
  def prepare_srcdir
    src_dir = Pathname.new(fs.package_dirs.fetch(:src))

    purge(src_dir, options)
    skel_dirs(src_dir, fs.source_files, options)

    fs.source_files.map do |path|
      origin = path.realpath # resolves symlinks

      cp(origin, src_dir.join(path), **options.merge(preserve: true))
    end

    self
  end

  def verbose?
    options[:verbose] == true
  end

  protected

  # @return [Hash{Symbol => Object}]
  attr_reader :options
end
