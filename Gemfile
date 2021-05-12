# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.1"
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", ">= 1.4.4", require: false
gem "pg", "~> 1.2", ">= 1.2.3"
gem "puma", "~> 5.3", ">= 5.3.1"
gem "rails", "~> 6.1.3", ">= 6.1.3.2"
gem "sass-rails", ">= 6"
gem "turbolinks", "~> 5.2", ">= 5.2.1"
gem "webpacker", "~> 6.0.0.beta.7"

group :development do
  gem "listen", "~> 3.5", ">= 3.5.1"
  gem "spring"
end
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# End default rails

group :development do
  gem "annotate", "~> 3.1", ">= 3.1.1"
  gem "foreman", "~> 0.87.2"
  gem "guard", "~> 2.16", ">= 2.16.2"
  gem "guard-livereload", "~> 2.5", ">= 2.5.2"
  gem "rack-livereload", "~> 0.3.17"
  gem "rubocop-rails_config", "~> 1.5", ">= 1.5.3"
end

group :development, :test do
  gem "factory_bot_rails", "~> 6.2"
  gem "rspec-rails", "~> 5.0", ">= 5.0.1"
  gem "spring-commands-rspec", "~> 1.0", ">= 1.0.4"
end

group :test do
  gem "database_cleaner-active_record", "~> 2.0", ">= 2.0.1"
end

gem "attributes_sanitizer", "~> 0.1.6"
gem "email_validator", "~> 2.2", ">= 2.2.3"
gem "lockbox", "~> 0.6.4"
gem "rbnacl", "~> 7.1", ">= 7.1.1"
