source 'https://rubygems.org'
ruby '2.3.0'

gem 'rails', '4.2.6'
gem 'sqlite3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

gem 'spree',              '~> 3.0.9'
gem 'spree_auth_devise',  '~> 3.0.6'
gem 'spree_gateway',      '~> 3.0.0'
gem 'spree_yandex_kassa', git:    'git@github.com:SecretAgents/yandex_kassa.git',
                          branch: 'afd29aa2f7e03bcfad0cc5be2eff690fcd571437'

# gem 'activeadmin', '~> 1.0.0.pre1'
# gem 'dotenv-rails'
# gem "paperclip", "~> 5.0.0.beta1"
gem 'pg' # PostgreSQL adapter
gem 'russian', '~> 0.6.0'
gem 'slim' # Markup
gem 'thin' # HTTP server

group :development, :test do
  gem 'byebug'
end
group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
end
# gem 'bootstrap-sass'
# gem 'devise'
# gem 'high_voltage'
# gem 'pundit'
group :development do
  gem 'better_errors'
  gem 'quiet_assets'
  # gem 'rails_layout'
  gem 'spring-commands-rspec'
end
group :development do
  gem 'capistrano-rails',   '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1.2', require: false
  gem 'capistrano-passenger'
  gem 'capistrano-rvm',     '~> 0.1', require: false
  gem 'capistrano-faster-assets', '~> 1.0'
end

# Riding without tests
group :development, :test do
  # gem 'factory_girl_rails'
  # gem 'faker'
  # gem 'rspec-rails'
end
group :test do
  # gem 'capybara'
  # gem 'database_cleaner'
  # gem 'launchy'
  # gem 'selenium-webdriver'
end
