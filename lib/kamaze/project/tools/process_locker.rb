# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../tools'
require 'etc'
require 'fileutils'
require 'pathname'
require 'tmpdir'
require 'process_lock'

module Kamaze::Project::Tools
  class ProcessLocker < BaseTool
  end
end

# Process Locker
#
# @see https://github.com/ianheggie/process_lock
class Kamaze::Project::Tools::ProcessLocker < Kamaze::Project::Tools::BaseTool
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
  rescue ProcessLock::AlreadyLocked
    raise Errno::EALREADY if mklock(lockname).alive?
    raise
  end

  # @return [Pathname]
  def tmpdir
    tmp = Pathname.new(Dir.tmpdir)
    uid = Etc.getpwnam(Etc.getlogin).uid
    dir = [inflector.underscore(self.class.name).tr('/', '-'), uid].join('.')

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
  # @param [String] lockname
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
    options[:mode] ||= 0o700

    FileUtils.mkdir_p(tmpdir, options)

    tmpdir
  end

  # @return [Dry::Inflector]
  def inflector
    require 'dry/inflector'

    Dry::Inflector.new
  end
end
