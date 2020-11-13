ARG RUBY_VERSION=2.6.6
FROM ruby:${RUBY_VERSION}-alpine

ARG BUNDLER_VERSION=1.17.2

RUN apk add --update --no-cache \
    yarn \
    git \
    build-base \
    postgresql-dev \
    tzdata \
    imagemagick

ENV BUNDLER_VERSION ${BUNDLER_VERSION}
RUN gem install bundler:${BUNDLER_VERSION}

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY package.json yarn.lock ./
RUN yarn install --check-files

COPY . .

EXPOSE 3000
CMD ["rails", "s", "-b", "0.0.0.0", "-p", "3000"]
