# frozen_string_literal: true

# bundle install --path vendor/bundle --clean

source 'https://rubygems.org'

# base ---------------------------------------------------------------

gem 'cli-ui', '~> 1.1'
gem 'cliver', '~> 0.3'
gem 'dotenv', '~> 2.4'
gem 'dry-inflector', '~> 0.1'
gem 'process_lock', '~> 0.1'
gem 'rake', '~> 12.3'
gem 'rugged', '~> 0.27'
gem 'tenjin', '~> 0.7'
gem 'tty-editor', '~> 0.4'
gem 'tty-screen', '>= 0.6.2', '~> 0.6'

# supported tools ----------------------------------------------------

gem 'rubocop', '~> 0.56'
gem 'yard', '~> 0.9'

# --------------------------------------------------------------------
# 'rspec' and 'pry' are also supported, but we don't force to use it

# development, doc, test ---------------------------------------------

group :development do
  gem 'bootsnap', '~> 1.3'
  gem 'interesting_methods', '~> 0.1'
  gem 'pry', '~> 0.11'
  gem 'pry-coolline', '~> 0.2'
  gem 'sys-proc', '~> 1.1'

  # 'listen' is used to "watch"
  # but could be incompatible with some systems
  gem 'listen', '~> 3.1'
end

group :doc, :development do
  gem 'github-markup', '~> 2.0'
  gem 'redcarpet', '~> 3.4'
end

group :test, :development do
  gem 'factory_bot', '~> 4.8'
  gem 'fuubar', '~> 2.3'
  gem 'mocha', '~> 1.5'
  gem 'rspec', '~> 3.7'
end
