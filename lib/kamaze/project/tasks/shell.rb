# frozen_string_literal: true

# Start a REPL
#
# @see [Kamaze::Project::Tools::Shell]

# task ---------------------------------------------------------------
desc 'Start ruby REPL'
task :shell do
  tools.fetch(:shell).start
end
