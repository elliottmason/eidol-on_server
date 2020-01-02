# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.6.3'

gem 'rails', '~> 6.0.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'

# Use Puma as the app server
gem 'puma', '~> 3.11'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS)
gem 'rack-cors'

# Use Seedbank to structure our seed data
gem 'seedbank'

# Use Wisper for publishing and subscribing to events
gem 'wisper', '~> 2.0.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to get a debugger console
  gem 'byebug', platforms: %i[mingw mri x64_mingw]

  # Use factory_bot in place of fixtures
  gem 'factory_bot_rails'

  # Use Faker to generate fake data for factories
  gem 'faker'

  # Use RSpec as our testing framework
  gem 'rspec-rails', '~> 3.8'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'

  # Use Pry as our Ruby shell
  gem 'pry-rails'

  # Use Reek to detect code smells
  gem 'reek'

  # Use RuboCop to analyze our code
  gem 'rubocop', require: false
  gem 'rubocop-rails'

  # Use Solargraph as a Ruby language server
  gem 'solargraph'
end

group :test do
  # Use SimpleCov for code coverage analysis
  gem 'simplecov', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[jruby mingw mswin x64_mingw]
