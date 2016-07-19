source 'https://rubygems.org'
ruby `cat .ruby-version`

# Base
gem 'rails', '4.2.6'
gem 'sqlite3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'

# Shop
gem 'spree',              '~> 3.0.9'
gem 'spree_auth_devise',  '~> 3.0.6'
gem 'spree_gateway',      '~> 3.0.0'
gem 'spree_yandex_kassa', git:    'https://github.com/SecretAgents/yandex_kassa.git',
                          branch: 'afd29aa2f7e03bcfad0cc5be2eff690fcd571437'

gem 'acts_as_list' # List operations for models
gem 'mercury-rails', github: 'jejacks0n/mercury' # Inline content editor
gem 'pg' # PostgreSQL adapter
gem 'russian', '~> 0.6.0'
gem 'slim' # Markup
gem 'thin' # HTTP server

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'guard-livereload', '~> 2.5', require: false # Autoreload browser
  gem 'better_errors' # Detailed output in browser
  gem 'quiet_assets'
  gem 'spring-commands-rspec'

  # Deploy
  gem 'capistrano-rails',   '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1.2', require: false
  gem 'capistrano-passenger'
  gem 'capistrano-rvm',     '~> 0.1', require: false
  gem 'capistrano-faster-assets', '~> 1.0'
end

# # Riding without tests
# group :development, :test do
#   gem 'factory_girl_rails'
#   gem 'faker'
#   gem 'rspec-rails'
# end
# group :test do
#   gem 'capybara'
#   gem 'database_cleaner'
#   gem 'launchy'
#   gem 'selenium-webdriver'
# end
