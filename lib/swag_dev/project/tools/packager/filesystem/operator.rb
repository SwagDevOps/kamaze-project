# frozen_string_literal: true

require 'pathname'
require_relative '../filesystem'
require_relative 'operator/utils'

# Filesystem operator (manipulator)
#
# This class is intended to manipulate a ``Filesystem``.
class SwagDev::Project::Tools::Packager::Filesystem::Operator
  include self.const_get(:Utils)

  # @return [SwagDev::Project::Tools::Packager::Filesystem]
  attr_reader :fs

  # #return [Hash]
  attr_reader :options

  # @param [SwagDev::Project::Tools::Packager::Filesystem] filesystem
  # @param [Hash] options
  # @see fs
  def initialize(filesystem, options = {})
    @fs = filesystem
    @options = { verbose: true }.merge(options.to_h)

    # Pass included methods to protected
    utils_methods.each do |m|
      if self.public_methods.include?(m)
        self.singleton_class.class_eval { protected m }
      end
    end
  end

  # Prepare package
  #
  # @return [self]
  def prepare
    fs.package_dirs.each_value { |dir| mkdir_p(dir, options) }
    prepare_srcdir

    self
  end

  # Prepare ``src`` dir
  #
  # Source files are refreshed (deleted and copied again)
  #
  # @return [self]
  def prepare_srcdir
    src_dir = ::Pathname.new(fs.package_dirs.fetch(:src))

    purge(src_dir, options)
    skel_dirs(src_dir, fs.source_files, options)

    fs.source_files.map do |path|
      origin = path.realpath # resolves symlinks

      cp(origin, src_dir.join(path), options.merge(preserve: true))
    end

    self
  end
end
