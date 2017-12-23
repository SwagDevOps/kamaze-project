# frozen_string_literal: true

# bundle install --path vendor/bundle

source 'https://rubygems.org'

# base ---------------------------------------------------------------
gem 'rake', '~> 12.3'
gem 'activesupport', '~> 5.1'
gem 'version_info', '~> 1.9'
gem 'sham', '~> 1.2'
gem 'cliver', '= 0.3.2'
gem 'gemspec_deps_gen', '= 1.1.2'
gem 'tenjin', '~> 0.7'
gem 'cli-ui', '~> 1.0', '>= 1.0.0'
gem 'tty-editor', '~> 0.2'
gem 'tty-screen', '~> 0.6', '>= 0.6.2'
gem 'dotenv', '~> 2.2'
gem 'process_lock', '~> 0.1'

# supported tools ----------------------------------------------------
gem 'pry', '~> 0.11'
gem 'yard', '~> 0.9'
gem 'rubocop', '~> 0.52'
# 'rspec' is also supported, but we don't force to use it

group :development do
  gem 'sys-proc', '~> 1.0', '>= 1.0.4'

  # 'listen' is used to "watch"
  # but could be incompatible with some systems
  gem 'listen', '~> 3.1'
end

group :doc, :development do
  gem 'redcarpet', '~> 3.4'
  gem 'github-markup', '~> 1.6'
end

group :test, :development do
  gem 'rspec', '~> 3.7'
  gem 'factory_bot', '~> 4.8'
end
