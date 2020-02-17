# frozen_string_literal: true

# bundle install --path vendor/bundle --clean

source 'https://rubygems.org'

group :default do
  gem 'cli-ui', '~> 1.3'
  gem 'cliver', '~> 0.3'
  gem 'dotenv', '~> 2.7'
  gem 'dry-inflector', '~> 0.1'
  gem 'kamaze-version', '~> 1.0'
  gem 'process_lock', '~> 0.1'
  gem 'rake', '~> 12.3'
  gem 'rugged', '~> 0.28'
  gem 'tenjin', '~> 0.7'
  gem 'tty-editor', '~> 0.5'
  gem 'tty-screen', '>= 0.6.2', '~> 0.7'
end

# --------------------------------------------------------------------
# 'rspec', 'rubocop' and 'yard' are supported tools
# but we don't force to use them
# --------------------------------------------------------------------

group :development do
  gem 'bootsnap', '~> 1.4'
  gem 'rubocop', '~> 0.79'
  gem 'sys-proc', '~> 1.1'

  # 'listen' is used to "watch"
  # but could be incompatible with some systems
  gem 'listen', '~> 3.2'
end

group :repl do
  gem 'interesting_methods', '~> 0.1'
  gem 'pry', '~> 0.12'
  gem 'pry-coolline', '~> 0.2'
end

group :doc do
  gem 'github-markup', '~> 3.0'
  gem 'redcarpet', '~> 3.5'
  gem 'yard', '~> 0.9'
end

group :test do
  gem 'fuubar', '~> 2.5'
  gem 'mocha', '~> 1.11'
  gem 'rspec', '~> 3.7'
  gem 'sham', '~> 2.0'
end
