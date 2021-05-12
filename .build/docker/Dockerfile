FROM ruby:3.0.1

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash

RUN apt-get update && \
  apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs

RUN npm install -g yarn

RUN npm install -g phantomjs-prebuilt-that-works --unsafe-perm

RUN apt-get install -y libsodium-dev

RUN mkdir -p /app
WORKDIR /app