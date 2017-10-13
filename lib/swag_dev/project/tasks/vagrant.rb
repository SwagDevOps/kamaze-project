# frozen_string_literal: true

require 'swag_dev/project/dsl'
require 'rake/clean'

vagrant = project.tools.fetch(:vagrant)

CLOBBER.include('Vagrantfile')

file 'Vagrantfile': vagrant.source_files do
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
    rescue SystemExit, Interrupt
    end
  end
end

desc "Dump config"
task 'vagrant:dump', [:output] => ['vagrant:init'] do |task, args|
  out_file = Pathname.new(args[:output] || '/dev/stdout')
  dump = vagrant.dump

  Pathname.new(out_file).write(dump)
end

# :vagrant:vm --------------------------------------------------------

vagrant.boxes.each do |box, box_config|
  [:up, :halt, :reload, :provision, :rsync].each do |command|
    desc "%s #{box}" % command.to_s.gsub(/(\w+)/) { |s| s.capitalize }
    task "vagrant:vm:#{box}:#{command}": ['vagrant:init'] do
      vagrant.execute(command.to_s, box)
    end
  end

  desc "Ssh #{box}"
  task "vagrant:vm:#{box}:ssh", [:command] => ['vagrant:init'] do |task, args|
    command = args[:command]
    params  = ['ssh', box]
    if command and command[0] == ':'
      command = box_config.fetch('ssh_commands')
                          .fetch(command.gsub(/^:/, ''))
    end
    params += ['-c', command] if command
    vagrant.execute(*params)
  end
end