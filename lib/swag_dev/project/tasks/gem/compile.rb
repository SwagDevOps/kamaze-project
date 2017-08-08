# frozen_string_literal: true

require 'swag_dev/project'
require 'swag_dev/project/tasks/gem'
require 'rake/clean'
require 'cliver'

project      = SwagDev::Project.new
executables  = (project.gem.spec&.executables).to_a
pkg_dir      = "pkg/#{project.name}-#{project.version_info[:version]}"
sys          = RbConfig::CONFIG
build_dir    = Pathname.new(Dir.pwd)
                       .join('build', sys['host_os'], sys['host_cpu'])
build_dirs   = { src: nil, tmp: nil, bin: nil }
  .map { |k, str| [k, build_dir.join(k.to_s)] }.to_h

if executables.size > 0 and Cliver.detect(:rubyc)
  CLOBBER.include(build_dir)

  namespace :gem do
    desc 'compile executable%s %s' % [
           executables.size > 1 ? 's' : nil,
           executables
         ]
    task compile: [
           'gem:package',
           'gem:compile:prepare',
           'gem:compile:install',
           'gem:compile:compile',
         ]

    namespace :compile do
      # prepare directories for compiler
      task :prepare do
        rm_rf(build_dirs[:src])
        [:src, :bin, :tmp]
          .map { |name| build_dirs.fetch(name) }
          .map(&:to_s).sort.each { |dir| mkdir_p(dir) }

        Dir.glob(["#{pkg_dir}/*", '.bundle', 'vendor',
                  "*.gemspec", 'Gemfile', 'Gemfile.lock'])
           .sort
           .each { |path| cp_r(path, build_dirs[:src]) }
      end

      # install dependencies
      task :install do
        Bundler.with_clean_env do
          Dir.chdir(build_dirs.fetch(:src)) do
            sh(Cliver.detect!(:bundle), 'install',
               '--path', 'vendor/bundle', '--clean',
               '--without', 'development', 'doc', 'test')
          end
        end
      end

      # compile executables
      task :compile do
        Bundler.with_clean_env do
          project.gem.spec.executables.each do |executable|
            Dir.chdir(build_dirs.fetch(:src)) do
              sh(ENV.to_h, Cliver.detect!(:rubyc),
                 [project.gem.spec.bindir, executable].join('/'),
                 '-d', "#{build_dirs.fetch(:tmp)}",
                 '-r', "#{build_dirs.fetch(:src)}",
                 '-o', "#{build_dirs.fetch(:bin).join(executable)}")
            end
          end
        end
      end
    end
  end
end
