# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.1"
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", ">= 1.4.4", require: false
gem "pg", "~> 1.2", ">= 1.2.3"
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
  gem "better_errors", "~> 2.9", ">= 2.9.1"
  gem "binding_of_caller", "~> 1.0"
  gem "foreman", "~> 0.87.2"
  gem "guard", "~> 2.16", ">= 2.16.2"
  gem "guard-livereload", "~> 2.5", ">= 2.5.2"
  gem "puma", "~> 5.3", ">= 5.3.1"
  gem "rack-livereload", "~> 0.3.17"
  gem "rubocop-rails_config", "~> 1.5", ">= 1.5.3"
end

group :development, :test do
  gem "brakeman", "~> 5.0", ">= 5.0.1"
  gem "bundler-audit"
  gem "erb_lint", require: false
  gem "factory_bot_rails", "~> 6.2"
  gem "ffaker", "~> 2.18"
  gem "pry-rails", "~> 0.3.9"
  gem "rspec-rails", "~> 5.0", ">= 5.0.1"
  gem "spring-commands-rspec", "~> 1.0", ">= 1.0.4"
end

group :test do
  gem "database_cleaner-active_record", "~> 2.0", ">= 2.0.1"
end

group :test, :production do
  gem "falcon", "~> 0.38.1"
end

gem "attributes_sanitizer", "~> 0.1.6"
gem "bitwise_attribute", github: "rikas/bitwise_attribute", ref: "36371f6511a5907d1ec96385e0baca55d935cb99"
gem "email_validator", "~> 2.2", ">= 2.2.3"
gem "hcaptcha", github: "Nexus-Mods/hcaptcha", ref: "a2135327e0f22ddba170d77dbba86827cd05c2cb"
gem "jb", "~> 0.8.0"
gem "lockbox", "~> 0.6.4"
gem "rbnacl", "~> 7.1", ">= 7.1.1"
gem "validates_host", "~> 1.3"
