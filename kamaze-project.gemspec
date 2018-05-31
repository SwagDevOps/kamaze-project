# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# rubocop:disable all

# MUST follow the higher required_ruby_version
# requires version >= 2.3.0 due to safe navigation operator &

Gem::Specification.new do |s|
  s.name        = 'kamaze-project'
  s.version     = '1.0.1'
  s.date        = '2018-05-29'
  s.summary     = 'Automatize recurrent dev tasks with swag'
  s.description = 'A bunch of (rake) tasks to automatize your development workflow.'

  s.licenses    = ["GPL-3.0"]
  s.authors     = ["Dimitri Arrigoni"]
  s.email       = 'dimitri@arrigoni.me'
  s.homepage    = 'https://github.com/SwagDevOps/kamaze-project'

  s.required_ruby_version = '>= 2.3.0'
  s.require_paths = ['lib']
  s.files         = [
    '.yardopts',
    '.rubocop.yml',
    'bin/*',
    'lib/**/*.rb',
    'lib/**/resources/**/**',
    'lib/**/version.yml'
  ].map { |m| Dir.glob(m) }.flatten
   .map { |f| File.file?(f) ? f : nil }.compact

  s.add_runtime_dependency("cli-ui", ["~> 1.1"])
  s.add_runtime_dependency("cliver", ["~> 0.3"])
  s.add_runtime_dependency("dotenv", ["~> 2.4"])
  s.add_runtime_dependency("dry-inflector", ["~> 0.1"])
  s.add_runtime_dependency("process_lock", ["~> 0.1"])
  s.add_runtime_dependency("rake", ["~> 12.3"])
  s.add_runtime_dependency("rugged", ["~> 0.27"])
  s.add_runtime_dependency("tenjin", ["~> 0.7"])
  s.add_runtime_dependency("tty-editor", ["~> 0.4"])
  s.add_runtime_dependency("tty-screen", [">= 0.6.2", "~> 0.6"])
  s.add_runtime_dependency("rubocop", ["~> 0.56"])
  s.add_runtime_dependency("yard", ["~> 0.9"])
end

# Local Variables:
# mode: ruby
# End:
