FROM ruby:2.3.0
RUN apt-get update && apt-get install vim -y apache2 -y libpq-dev -y build-essential -y nodejs
RUN mkdir my-road-trip
WORKDIR /my-road-trip
ADD Gemfile /my-road-trip/Gemfile
ADD Gemfile.lock /my-road-trip/Gemfile.lock
RUN gem install rails
RUN gem install bundler
RUN bundle install
ADD . /my-road-trip
CMD RAILS_ENV=it bundle exec rake db:create db:migrate db:seed && rails server -b 0.0.0.0 -p 80