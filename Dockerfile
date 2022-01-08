FROM ruby:3.0.3
ENV DEVELOPER=true
ENV RAILS_ENV=production

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash

RUN apt-get update && \
  apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs

RUN npm install -g yarn

RUN apt-get install -y libsodium-dev p7zip-full libwebp-dev libvips-dev libexif-dev

RUN mkdir -p /app
WORKDIR /app
COPY . ./

RUN gem install bundler
RUN bundle config set --local without 'development test'
RUN bundle install --jobs 4

RUN DEVELOPER=true RAILS_ENV=production SECRET_KEY_BASE=placeholder \
    bundle exec rake assets:precompile

RUN rm -rf node_modules spec/* .git/*
