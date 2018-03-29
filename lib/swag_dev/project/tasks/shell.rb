# frozen_string_literal: true

# Start a REPL
#
# @see [SwagDev::Project::Tools::Shell]

# task ---------------------------------------------------------------
desc 'Start ruby REPL'
task :shell do
  shell = SwagDev.project.tools.fetch(:shell)

  shell.start
end
