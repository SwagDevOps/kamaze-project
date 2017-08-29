# frozen_string_literal: true

require 'swag_dev/project/dsl'
require 'swag_dev/project/tasks/gem'
require 'rake/clean'

CLOBBER.include(sham!.build_dirs.values)

(desc "compile executable%s #{sham!.executables}" % {
        true  => nil,
        false => 's'
      }[1 == sham!.executables.size]) unless sham!.executables.empty?
task 'gem:compile': [
       'gem:package',
       'gem:compile:prepare',
       'gem:compile:install',
       'gem:compile:compile',
     ]

# prepare directories for compiler
task :'gem:compile:prepare' do
  rm_rf(sham!.build_dirs[:src])

  sham!.build_dirs.each { |_k, dir| mkdir_p(dir) }

  Dir.glob(sham!.src_globs)
     .sort
     .each { |path| cp_r(path, sham!.build_dirs[:src]) }
end

# install dependencies
task :'gem:compile:install' do
  Bundler.with_clean_env do
    Dir.chdir(sham!.build_dirs.fetch(:src)) do
      sh(sham!.bundler, 'install',
         '--path', 'vendor/bundle', '--clean',
         '--without', 'development', 'doc', 'test')
    end
  end
end

# compile executables
task :'gem:compile:compile' do
  sham!.executables.each do |executable|
    Dir.chdir(project.path(sham!.build_dirs.fetch(:src))) do
      tmp_dir = project.path(sham!.build_dirs.fetch(:tmp))
      bin_dir = project.path(sham!.build_dirs.fetch(:bin), executable)

      Bundler.with_clean_env do
        sh(ENV.to_h, sham!.compiler,
           "#{project.gem.spec.bindir}/#{executable}",
           '-r', '.',
           '-d', "#{tmp_dir}",
           '-o', "#{bin_dir}")
      end
    end
  end
end
