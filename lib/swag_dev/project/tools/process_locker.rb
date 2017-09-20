# frozen_string_literal: true

require 'swag_dev/project/tools'
require 'etc'
require 'fileutils'
require 'pathname'
require 'tmpdir'
require 'process_lock'
require 'active_support/inflector'

class SwagDev::Project::Tools::ProcessLocker
  # Manage lock on given block
  #
  # @return [Object]
  def lock(lockname)
    mklock(lockname).acquire { yield }
  end

  # Manage lock on given block
  #
  # @raise [Errno::EALREADY]
  # @raise [ProcessLock::AlreadyLocked]
  # @return [Object]
  def lock!(lockname)
    mklock(lockname).acquire! { yield }
  rescue ProcessLock::AlreadyLocked => e
    raise Errno::EALREADY if mklock(lockname).alive?
    raise
  end

  # @return [Pathname]
  def tmpdir
    tmp = Pathname.new(Dir.tmpdir)
    uid = Etc.getpwnam(Etc.getlogin).uid
    dir = [inflector.underscore(self.class.name).gsub('/', '-'), uid].join('.')

    tmp.join(dir)
  end

  class << self
    def method_missing(method, *args, &block)
      if respond_to_missing?(method)
        self.new.public_send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      return true if self.new.respond_to?(method, include_private)

      super(method, include_private)
    end
  end

  protected

  # @param [String] lockname
  # @return [ProcessLock]
  def mklock(lockname)
    lockfile = mktemp(lockname)

    ProcessLock.new(lockfile)
  end

  # Create a temporary file
  #
  # @param [String]
  # @return [Pathname]
  def mktemp(lockname)
    lockname = Pathname.new(lockname.to_s).basename('.*')

    mktmpdir.join(lockname)
  end

  # Create ``tmpdir``
  #
  # @param [Hash] options
  # @return [Pathname]
  def mktmpdir(options = {})
    tmpdir = self.tmpdir
    options[:mode] ||= 0700

    FileUtils.mkdir_p(tmpdir, options)

    tmpdir
  end

  def inflector
    ActiveSupport::Inflector
  end
end
