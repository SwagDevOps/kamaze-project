# frozen_string_literal: true

# bundle install --path vendor/bundle --clean

source 'https://rubygems.org'

# base ---------------------------------------------------------------

gem 'activesupport', '~> 5.1'
gem 'cli-ui', '~> 1.0', '>= 1.0.0'
gem 'cliver', '= 0.3.2'
gem 'dotenv', '~> 2.2'
gem 'gemspec_deps_gen', '= 1.1.2'
gem 'process_lock', '~> 0.1'
gem 'rake', '~> 12.3'
gem 'sham', '~> 1.2'
gem 'tenjin', '~> 0.7'
gem 'tty-editor', '~> 0.2'
gem 'tty-screen', '~> 0.6', '>= 0.6.2'
gem 'version_info', '~> 1.9'

# supported tools ----------------------------------------------------

gem 'pry', '~> 0.11'
gem 'rubocop', '~> 0.52'
gem 'yard', '~> 0.9'
# 'rspec' is also supported, but we don't force to use it

# development, doc, test ---------------------------------------------

group :development do
  gem 'sys-proc', '~> 1.0', '>= 1.0.4'

  # 'listen' is used to "watch"
  # but could be incompatible with some systems
  gem 'listen', '~> 3.1'
end

group :doc, :development do
  gem 'github-markup', '~> 1.6'
  gem 'redcarpet', '~> 3.4'
end

group :test, :development do
  gem 'factory_bot', '~> 4.8'
  gem 'rspec', '~> 3.7'
end
