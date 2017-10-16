# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby
#
# Should follow the higher required_ruby_version
# at the moment, gem with higher required_ruby_version is activesupport
# but requires version >= 2.3.0 with safe navigation operator &

Gem::Specification.new do |s|
  s.name        = '#{@name}'
  s.version     = '#{@version}'
  s.date        = '#{@date}'
  s.summary     = '#{@summary}'
  s.description = '#{@description}'

  s.licenses    = #{@licenses}
  s.authors     = #{@authors}
  s.email       = '#{@email}'
  s.homepage    = '#{@homepage}'

  s.required_ruby_version = '>= 2.3.0'
  s.require_paths = ['lib']
  s.files         = [
    '.yardopts',
    'bin/*',
    'lib/**/*.rb',
    'lib/**/resources/**',
    'lib/**/version_info.yml'
  ].map { |m| Dir.glob(m) }.flatten
   .map { |f| File.file?(f) ? f : nil }.compact

  #{@dependencies}
end

# Local Variables:
# mode: ruby
# eval: (rufo-minor-mode 0);
# End:
