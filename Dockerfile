FROM heroku/heroku:20

RUN apt-get update && \
    apt-get install -y libsodium-dev p7zip-full libwebp-dev libvips-dev libexif-dev

RUN mkdir -p /app
WORKDIR /app
COPY . ./

RUN gem install bundler
RUN bundle install --jobs 20
RUN yarn install
RUN bundle exec rake assets:precompile