# frozen_string_literal: true

require 'kamaze/project'

Kamaze.project do |c|
  c.subject = Kamaze::Project
  c.name = 'kamaze-project'
  # noinspection RubyLiteralArrayInspection
  c.tasks = [
    'cs', 'cs:pre-commit', 'doc', 'doc:watch',
    'gem', 'gem:install', 'gem:compile', 'gem:push',
    'misc:gitignore',
    'shell', 'sources:license', 'test', 'vagrant', 'version:edit',
  ].shuffle
end.load!
