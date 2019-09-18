FROM ruby:2.6.3

RUN gem update --system
RUN gem install bundler

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN rm -rf /var/lib/apt/lists/* && \
  apt-get update -qq && \
  apt-get install -y build-essential libssl-dev nano postgresql yarn --no-install-recommends

RUN mkdir /api
WORKDIR /api
