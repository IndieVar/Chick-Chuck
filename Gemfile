# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Default gems
ruby '3.4.12'
gem 'rails', '8.1.4.1'

gem 'active_analytics'
gem 'bootsnap', '~> 1.26', require: false
gem 'carrierwave', '~> 3.0'
gem 'crawler_detect'
gem 'devise', '~> 5.0'
gem 'devise-i18n', '~> 1.16'
gem 'draper'
gem 'faker', '~> 3.8'
gem 'file_validators'
gem 'fog-aws'
gem 'image_processing', '~> 1.2'
gem 'importmap-rails'
gem 'jbuilder', '~> 2.15'
gem 'meta-tags'
gem 'noticed', '~> 1.6'
gem 'nokogiri', '>= 1.18.0'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'ostruct'
gem 'pagy', '~> 6.0'
gem 'pg', '~> 1.1'
gem 'phonelib'
gem 'premailer-rails'
gem 'puma', '~> 6.0'
gem 'rails_heroicon'
gem 'rails-i18n', '~> 8.0.0'
gem 'redis', '~> 5.0'
gem 'sassc-rails'
gem 'sidekiq', '~> 7.0'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'tailwindcss-rails', '~> 2.0.30'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'view_component', '~> 3.22'
# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'letter_opener'
  gem 'rspec-rails', '~> 7.0'
end

group :development do
  gem 'rubocop', require: false
  gem 'web-console'
end

gem 'dockerfile-rails', '>= 1.3', group: :development

gem "aws-sdk-s3", "~> 1.240", require: false
