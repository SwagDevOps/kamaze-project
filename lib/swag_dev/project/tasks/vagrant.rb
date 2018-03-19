# frozen_string_literal: true

require 'swag_dev/project'
require 'rake/clean'
require 'shellwords'
require 'yaml'

vagrant = SwagDev.project.tools.fetch(:vagrant)

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
  task "vagrant:#{k}": ['vagrant:init'] do
    begin
      vagrant.execute(k.to_s)
      # rubocop:disable Lint/HandleExceptions
    rescue SystemExit, Interrupt
      # rubocop:enable Lint/HandleExceptions
    end
  end
end

desc 'Dump config'
task 'vagrant:dump', [:box_id] => ['vagrant:init'] do |task, args|
  dump = args[:box_id] ? vagrant.boxes.fetch(args[:box_id]) : vagrant.boxes

  $stdout.puts(YAML.dump(dump))
end

# :vagrant:vm --------------------------------------------------------

vagrant.boxes.each_key do |box_id|
  task_ns = "vagrant:vm:#{box_id}"
  [:up, :halt, :reload, :provision, :rsync].each do |command|
    desc "#{command.to_s.gsub(/(\w+)/, &:capitalize)} #{box_id}"
    task "#{task_ns}:#{command}": ['vagrant:init'] do
      vagrant.execute(command.to_s, box_id)
    end
  end

  desc "Ssh #{box_id}"
  task "#{task_ns}:ssh", [:command] => ['vagrant:init'] do |task, args|
    vagrant.ssh(box_id, args[:command])
  end
end
