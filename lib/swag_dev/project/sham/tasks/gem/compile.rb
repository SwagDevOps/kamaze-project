# frozen_string_literal: true

require 'swag_dev/project'
require 'swag_dev/project/sham'
require 'pathname'
require 'cliver'

project   = SwagDev.project
sys       = RbConfig::CONFIG
build_dir = Pathname.new('build').join(sys['host_os'], sys['host_cpu'])
pkg_dir   = project.path('pkg', "#{project.name}-#{project.version_info[:version]}")
src_globs = ["#{pkg_dir}/*",
             '.bundle', 'vendor',
             "*.gemspec", 'Gemfile', 'Gemfile.lock']

SwagDev::Project::Sham.define('tasks/gem/compile') do |c|
  c.attributes do
    {
      executables: project.gem.spec.executables.to_a,
      compiler:    Cliver.detect!(:rubyc),
      bundler:     Cliver.detect!(:bundle),
      src_globs:   src_globs,
      build_dir:   build_dir,
      build_dirs:  { src: nil, tmp: nil, bin: nil }.map do |k, str|
        [k, build_dir.join(k.to_s)]
      end
    }
  end
end
