# frozen_string_literal: true

require 'swag_dev/project'
require 'swag_dev/project/rake/gemspec'
require 'rake/clean'
require 'cliver'

project = SwagDev::Project.new

CLOBBER.include('pkg')

desc 'Build all the packages'
task gem: ['gem:gemspec', 'gem:package']

namespace :gem do
  # desc Rake::Task[:gem].comment
  task package: FileList.new('gem:gemspec', 'lib/**/*.rb') do
    require 'rubygems/package_task'
    require 'securerandom'

    # internal namespace name
    ns = '_%s' % SecureRandom.hex(4)
    namespace ns do
      task = Gem::PackageTask.new(project.spec)
      task.define
      # Task management
      begin
        Rake::Task['%s:package' % ns].invoke
      rescue Gem::InvalidSpecificationException => e
        STDERR.puts(e)
        exit 1
      end
      Rake::Task['clobber'].reenable
    end
  end

  if (project.spec&.executables).to_a.size > 0 and Cliver.detect(:rubyc)
    CLOBBER.include('build')

    desc 'compile executables'
    task compile: ['gem:package'] do
      curdir = Pathname.new('.').realpath
      pkgdir = "pkg/#{project.name}-#{project.version_info[:version]}"
      srcdir = 'build/src'
      tmpdir = 'build/tmp'
      bindir = Pathname.new('build')
                       .join(RbConfig::CONFIG['host_os'])
                       .join(RbConfig::CONFIG['host_cpu'])

      Bundler.with_clean_env do
        rm_rf(srcdir)
        [srcdir, bindir, tmpdir]
          .map(&:to_s).sort.each { |dir| mkdir_p(dir) }
        Dir.glob(["#{pkgdir}/*", "*.gemspec", 'Gemfile', 'Gemfile.lock'])
           .sort
           .each { |path| cp_r(path, srcdir) }

        Dir.chdir(srcdir) do
          sh(Cliver.detect!(:bundle), 'install',
             '--path', 'vendor/bundle', '--clean',
             '--jobs', Etc.nprocessors.to_s,
             '--without', 'development', 'doc', 'test')

          project.spec.executables.each do |executable|
            sh(ENV.to_h, Cliver.detect!(:rubyc),
               "#{project.spec.bindir}/#{executable}",
               '-d', "#{curdir}/#{tmpdir}",
               '-r', "#{curdir}/#{srcdir}",
               '-o', "#{curdir}/#{bindir}/#{executable}")
            sh(Cliver.detect!(:strip),
               '-s', "#{curdir}/#{bindir}/#{executable}") if Cliver.detect(:strip)
            # tar -czfv bin.tgz bin/
          end
        end
      end
    end
  end

  desc 'Update gemspec'
  task gemspec: "#{project.name}.gemspec"

  desc 'Install gem'
  task install: ['gem:package'] do
    require 'cliver'

    sh(*[Cliver.detect(:sudo),
         Cliver.detect!(:gem),
         :install,
         project.gem].compact.map(&:to_s))
  end

  # @see http://guides.rubygems.org/publishing/
  # @see rubygems-tasks
  #
  # Code mostly base on gem executable
  desc 'Push gem up to the gem server'
  task push: ['gem:package'] do
    ['rubygems',
     'rubygems/gem_runner',
     'rubygems/exceptions'].each { |i| require i }

    args = ['push', project.gem]
    begin
      Gem::GemRunner.new.run(args.map(&:to_s))
    rescue Gem::SystemExitException => e
      exit e.exit_code
    end
  end
end
