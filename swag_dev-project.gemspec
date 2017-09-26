# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby
#
# Should follow the higher required_ruby_version
# at the moment, gem with higher required_ruby_version is activesupport
# but requires version >= 2.3.0 with safe navigation operator &

Gem::Specification.new do |s|
  s.name        = 'swag_dev-project'
  s.version     = '0.0.1'
  s.date        = '2017-08-06'
  s.summary     = 'Automatize recurrent dev tasks with swag'
  s.description = 'Provides a bunch of (rake) tasks to automatize with swag'

  s.licenses    = ["GPL-3.0"]
  s.authors     = ["Dimitri Arrigoni"]
  s.email       = 'dimitri@arrigoni.me'
  s.homepage    = 'https://github.com/SwagDevOps/ylem'

  s.required_ruby_version = '>= 2.3.0'
  s.require_paths = ['lib']
  s.files         = ['.yardopts',
                     'bin/*',
                     'lib/**/*.rb',
                     'lib/**/version_info.yml'
                    ].map { |pt| Dir.glob(pt) }.flatten

  s.add_runtime_dependency "rake", ["~> 12.0"]
  s.add_runtime_dependency "activesupport", ["~> 5.1"]
  s.add_runtime_dependency "version_info", ["~> 1.9"]
  s.add_runtime_dependency "sham", ["~> 1.1"]
  s.add_runtime_dependency "cliver", ["= 0.3.2"]
  s.add_runtime_dependency "gemspec_deps_gen", ["= 1.1.2"]
  s.add_runtime_dependency "tenjin", ["~> 0.7"]
  s.add_runtime_dependency "pastel", ["~> 0.7"]
  s.add_runtime_dependency "tty-editor", ["~> 0.2"]
  s.add_runtime_dependency "tty-screen", ["~> 0.5"]
  s.add_runtime_dependency "dotenv", ["~> 2.2"]
  s.add_runtime_dependency "process_lock", ["~> 0.1"]
  s.add_runtime_dependency "pry", ["~> 0.10"]
  s.add_runtime_dependency "yard", ["~> 0.9"]
  s.add_runtime_dependency "rubocop", ["~> 0.49"]
  s.add_development_dependency "listen", ["~> 3.1"]
  s.add_development_dependency "redcarpet", ["~> 3.4"]
  s.add_development_dependency "github-markup", ["~> 1.6"]
  s.add_development_dependency "rspec", ["~> 3.6"]
end

# Local Variables:
# mode: ruby
# eval: (rufo-minor-mode 0);
# End:
