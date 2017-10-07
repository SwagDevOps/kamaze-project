# frozen_string_literal: true
#
# bundle install --path vendor/bundle
source 'https://rubygems.org'

# base
gem 'rake', '~> 12.0'
gem 'activesupport', '~> 5.1'
gem 'version_info', '~> 1.9'
gem 'sham', '~> 1.1'
gem 'cliver', '= 0.3.2'
gem 'gemspec_deps_gen', '= 1.1.2'
gem 'tenjin', '~> 0.7'
gem 'pastel', '~> 0.7'
gem 'tty-editor', '~> 0.2'
gem 'tty-screen', '~> 0.5'
gem 'dotenv', '~> 2.2'
gem 'process_lock', '~> 0.1'

# supported tools
gem 'pry', '~> 0.10'
gem 'yard', '~> 0.9'
gem 'rubocop', '~> 0.49'
# 'rspec' is also supported, but we don't force to use it
# 'listen' is used to "watch" but could be incompatible with some systems

group :development do
  gem 'sys-proc', '~> 1.0', '>= 1.0.4'
  gem 'listen', '~> 3.1'
end

group :doc, :development do
  # Github Flavored Markdown in YARD
  gem 'redcarpet', '~> 3.4'
  gem 'github-markup', '~> 1.6'
end

group :test, :development do
  gem 'rspec', '~> 3.6'
end
