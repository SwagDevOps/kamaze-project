# frozen_string_literal: true

autoload(:Pathname, 'pathname')
require_relative '../lib/kamaze-project'
Pathname.new("#{__dir__}/..")
        .realpath
        .join('Rakefile')
        .yield_self { |file| self.instance_eval(file.read, file.to_s, 1) }

[
  :env,
  :constants,
  :progname,
  :factory_struct,
  :configure,
  :matchers,
].each do |req|
  require_relative '%<dir>s/%<req>s' % {
    dir: __FILE__.gsub(/\.rb$/, ''),
    req: req.to_s,
  }
end
