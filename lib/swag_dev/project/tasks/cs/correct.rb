# frozen_string_literal: true

require 'swag_dev/project/dsl'
require 'swag_dev/project/tasks/cs'
require 'pathname'

type = Pathname.new(__FILE__).basename('.rb')
desc sham!.description
task "cs:#{type}", [:path] => sham!.prerequisites do |t, args|
  patterns = args[:path] ? [args[:path]] : project.gem.spec.require_paths

  rubocop(patterns, sham: sham!).invoke
end
