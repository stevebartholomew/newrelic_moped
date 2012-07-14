# New Relic Moped

New Relic instrumentation for Moped / Mongoid 3

## Installation

Add these line to your application's Gemfile in the following order:

    gem 'rpm_contrib'
    gem 'newrelic_moped'
    gem 'newrelic_rpm'

And then execute:

    $ bundle

Update your `config/newrelic.yml` to disable Mongoid instrumentation:

    disable_mongoid: true

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
