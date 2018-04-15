# frozen_string_literal: true

# @see https://github.com/maier/vagrant-alpine

require 'vagrant-alpine/plugin'

# rubocop:disable all
module VagrantPlugins
  module GuestAlpine
    module Cap
      class RSync
        def self.rsync_installed(machine)
          machine.communicate.test('test -f /usr/bin/rsync')
        end

        def self.rsync_install(machine)
          machine.communicate.tap do |comm|
            comm.sudo('apk --no-cache add rsync')
          end
        end
      end
    end
  end
end
# rubocop:enable all
