FROM ruby:2.4.2

WORKDIR /app

ADD ./scripts /app/

RUN gem install marc
