FROM slapi/ruby:latest

MAINTAINER SLAPI Devs

ENV APP_HOME /newrelic

RUN mkdir -p $APP_HOME && chmod 777 $APP_HOME

WORKDIR /newrelic

# Copy app into container
COPY . $APP_HOME

RUN apk update && apk add \
    supervisor &&\
    if [ -f Gemfile.lock ]; then rm -f Gemfile.lock; fi &&\
    gem install bundler io-console &&\
    bundle install &&\
    rm -rf /var/cache/apk/* &&\
    rm -rf /tmp/*

EXPOSE 4700

ENTRYPOINT ["supervisord", "-c", "/newrelic/supervisord.conf", "-n"]
