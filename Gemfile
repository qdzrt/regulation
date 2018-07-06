source 'https://gems.ruby-china.com'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '5.2'
gem 'mysql2'
gem 'puma'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '~> 4.1.11'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks', '~> 5.1.1'
gem 'bootstrap-sass'
gem 'font-awesome-sass'
gem 'data-confirm-modal'

gem 'jbuilder'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
gem 'bcrypt'
gem 'rack-cors'
gem 'jwt'
gem 'grape'
gem 'grape-entity'
gem 'grape-swagger'
gem 'grape-swagger-rails'
# API的限流保护
gem 'grape-attack'
gem 'kaminari'

gem 'mini_magick'
gem 'activestorage_qiniu'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'simple_form'

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'database_cleaner'

  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'pry-rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
