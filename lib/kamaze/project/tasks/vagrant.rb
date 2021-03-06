# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require 'rake/clean'
require 'shellwords'
require 'yaml'

vagrant = tools.fetch(:vagrant)

CLOBBER.include('Vagrantfile')

file 'Vagrantfile': vagrant.sources do
  vagrant.install
end

task 'vagrant:init': ['Vagrantfile']

# :vagrant -----------------------------------------------------------
{
  'rsync-auto': 'Watch all rsync synced folders',
  'status': 'Current machine states',
}.each do |k, v|
  desc v
  task "vagrant:#{k}" => ['vagrant:init'] do |task|
    vagrant.execute(k.to_s)

    task.reenable
  end
end

desc 'Dump config'
task 'vagrant:dump', [:box_id] => ['vagrant:init'] do |task, args|
  dump = args[:box_id] ? vagrant.boxes.fetch(args[:box_id]) : vagrant.boxes

  $stdout.puts(YAML.dump(dump))

  task.reenable
end

# :vagrant:vm --------------------------------------------------------
vagrant.boxes.each do |box_id, config|
  next if config['disabled']

  task_ns = "vagrant:vm:#{box_id}"
  {
    up: [:halt],
    halt: [:up],
    reload: [:reload, :halt],
    provision: [:provision],
    rsync: [:rsync]
  }.each do |command, tasks|
    desc "#{command.to_s.gsub(/(\w+)/, &:capitalize)} #{box_id}"
    task "#{task_ns}:#{command}" => ['vagrant:init'] do
      vagrant.execute(command.to_s, box_id)

      tasks.each { |tid| Rake::Task["#{task_ns}:#{tid}"].reenable }
    end
  end

  desc "Ssh #{box_id}"
  task "#{task_ns}:ssh", [:command] => ['vagrant:init'] do |task, args|
    vagrant.ssh(box_id, args[:command])

    task.reenable
  end
end
