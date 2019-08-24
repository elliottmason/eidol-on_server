FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y build-essential  postgresql libssl-dev nodejs
WORKDIR /eidol-on-server
COPY Gemfile /eidol-on-server/Gemfile
COPY Gemfile.lock /eidol-on-server/Gemfile.lock
RUN bundle install
COPY . /eidol-on-server
