# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../vagrant'
require 'pathname'

class Kamaze::Project::Tools::Vagrant
  class Remote < Shell
  end
end

# Provide remote command execution (ssh)
#
# Commands can use aliases through configuration: ``box_id.ssh.aliases``;
# where ``box_id`` is the box identifier.
class Kamaze::Project::Tools::Vagrant::Remote
  # @return [Hash]
  attr_reader :boxes

  # Initialize remote shell with given boxes and options
  #
  # @param [Hash] boxes
  # @param [Hash] options
  def initialize(boxes, options = {})
    @boxes = boxes

    super(options)
  end

  # @return [Array]
  def to_a
    super.push('ssh')
  end

  # Run a command remotely on box identified by ``box_id``
  #
  # Sample of use:
  #
  # ```ruby
  # remote.execute(:freebsd)
  # remote.execute(:freebsd, 'rake clobber')
  # ```
  #
  # At least, one argument is required.
  def execute(*params, &block)
    box_id  = params.fetch(0)
    command = apply_alias(box_id, params[1]) # remote command
    params  = command ? [box_id, '-c', command] : [box_id]

    super(*params, &block)
  end

  protected

  # Apply alias on command for given ``box_id``
  #
  # @param [String] box_id
  # @param [String|nil] command
  # @return [String|nil]
  def apply_alias(box_id, command)
    return unless command

    conf = boxes.fetch(box_id.to_s) # fetch related config
    args = Shellwords.split(command) # command split into words
    exeb = conf['ssh']['aliases'][args[0]] # executable
    if exeb
      command = Shellwords.split(exeb)
                          .concat(args.drop(1))
                          .yield_self { |c| Shellwords.shelljoin(c) }
    end

    command
  end
end
