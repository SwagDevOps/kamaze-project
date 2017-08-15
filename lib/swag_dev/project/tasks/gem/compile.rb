# frozen_string_literal: true

require 'swag_dev/project'
require 'swag_dev/project/tasks/gem'
require 'rake/clean'
require 'cliver'

project = SwagDev.project
config  = project.sham!('tasks/gem/compile')
config.build_dirs = config.build_dirs.to_h

CLOBBER.include(config.build_dir) if config.build_dir

namespace :gem do
  desc "compile executable%s #{config.executables}" % {
    true  => nil,
    false => 's'
  }[1 == config.executables.size]
  task compile: [
         'gem:package',
         'gem:compile:prepare',
         'gem:compile:install',
         'gem:compile:compile',
       ]
end

namespace :gem do
  namespace :compile do
    # prepare directories for compiler
    task :prepare do
      rm_rf(config.build_dirs[:src])

      config.build_dirs.each do |_k, dir|
        mkdir_p(dir)
      end

      Dir.glob(config.src_globs)
         .sort
         .each { |path| cp_r(path, config.build_dirs[:src]) }
    end

    # install dependencies
    task :install do
      Bundler.with_clean_env do
        Dir.chdir(config.build_dirs.fetch(:src)) do
          sh(config.bundler, 'install',
             '--path', 'vendor/bundle', '--clean',
             '--without', 'development', 'doc', 'test')
        end
      end
    end

    # compile executables
    task :compile do
      pp "in compile"
      Bundler.with_clean_env do
        config.executables.each do |executable|
          Dir.chdir(config.build_dirs.fetch(:src)) do
            tmp_dir = project.path(config.build_dirs.fetch(:tmp))
            bin_dir = project.path(config.build_dirs.fetch(:bin), executable)

            sh(ENV.to_h, config.compiler,
               "#{project.gem.spec.bindir}/#{executable}",
               '-r', '.',
               '-d', "#{tmp_dir}",
               '-o', "#{bin_dir}")
          end
        end
      end
    end
  end
end
