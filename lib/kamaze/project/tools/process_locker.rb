# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../tools'

# Process Locker
#
# @see https://github.com/ianheggie/process_lock
class Kamaze::Project::Tools::ProcessLocker < Kamaze::Project::Tools::BaseTool
  autoload(:Digest, 'digest')

  # @formatter:off
  {
    Etc: 'etc',
    FileUtils: 'fileutils',
    Pathname: 'pathname',
    ProcessLock: 'process_lock',
  }.each { |s, fp| autoload(s, fp) }
  # @formatter:on

  # @return [String]
  attr_reader :lockdir

  def mutable_attributes
    [:lockdir]
  end

  # Set name for lockdir.
  #
  # @see #tmpdir
  # @see #setup
  def lockdir=(lockdir)
    inflector.classify(lockdir).yield_self { |s| inflector.underscore(s) }.tap do |name|
      @lockdir = name
    end
  end

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
    # noinspection RubyResolve
    raise Errno::EALREADY if mklock(lockname).alive?

    raise
  end

  # Get tmpdir where lock files are stored.
  #
  # @return [Pathname]
  def tmpdir
    require 'tmpdir' unless Dir.respond_to?(:tmpdir)

    Pathname.new(Dir.tmpdir).join('%<libname>s.%<uid>s' % { # @formatter:off
      libname: inflector.underscore(self.class.name).split('/')[0..1].join('-'),
      uid: Etc.getpwnam(Etc.getlogin).uid, # @formatter:on
    }, lockdir)
  end

  class << self
    def method_missing(method, *args, &block)
      if respond_to_missing?(method)
        return self.new.public_send(method, *args, &block)
      end

      super
    end

    def respond_to_missing?(method, include_private = false)
      return true if self.new.respond_to?(method, include_private)

      super(method, include_private)
    end
  end

  protected

  # @return [Dry::Inflector]
  attr_reader :inflector

  # @return [Module<FileUtils>]
  attr_reader :fs

  def setup
    @fs ||= FileUtils
    @inflector ||= Kamaze::Project::Inflector.new

    unless lockdir # rubocop:disable Style/GuardClause
      self.lockdir = lambda do
        return Kamaze::Project.instance.name if Kamaze::Project.instance

        Digest::SHA1.hexdigest(__FILE__) # Does not avoid collision if package is globally installed
      end.call
    end
  end

  # @param [String] lockname
  # @return [ProcessLock]
  def mklock(lockname)
    mktemp(lockname).yield_self { |lockfile| ProcessLock.new(lockfile) }
  end

  # Create a temporary file
  #
  # @param [String] lockname
  # @return [Pathname]
  def mktemp(lockname)
    Pathname.new(lockname.to_s).basename('.*').yield_self { |fp| mktmpdir.join(fp) }
  end

  # Create ``tmpdir``
  #
  # @return [Pathname]
  def mktmpdir(**options)
    self.tmpdir.tap do |tmpdir|
      options[:mode] ||= 0o700

      fs.mkdir_p(tmpdir, **options)
    end
  end
end
