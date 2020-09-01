# This gem is no longer maintained.  New Relic has first party support for Mongodb: https://github.com/newrelic/nri-mongodb

## New Relic Moped

New Relic instrumentation for Moped (1.x, 2.0) / Mongoid (3.x, 4.0)

## Important

This gem is compatible only with __newrelic_rpm__ >= 3.11

If you can't upgrade to __newrelic_rpm__ 3.11 or higher please use "__0.x__" branch of this gem.

Latest release of 0.x branch is v0.0.13

## Installation

Add this line to your application's Gemfile:

    gem 'newrelic_moped'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install newrelic_moped

### Sinatra, Resque, Sidekiq

When you don't use in Sinatra config.ru

    run Rack::URLMap.new '/' => Sinatra::Application

or you would like to instrument *Moped* usage in non-Rack configurations like *Resque*, *Sidekiq* or even in *irb*, you have to be sure that *newrelic_moped* is required **before** *newrelic_rpm*

    require 'newrelic_moped'
    require 'newrelic_rpm'

### Configuration

This gem does not require any specific configuration. Please follow general newrelic_rpm gem configuration:
https://github.com/newrelic/rpm/blob/master/newrelic.yml

## News

There's no official place for news & updates yet but you can follow @sbartholomew on Twitter for announcements.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
