# New Relic Moped

New Relic instrumentation for Moped / Mongoid 3

## Installation

Add this line to your application's Gemfile:

    gem 'newrelic_moped'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install newrelic_moped
    
## Configuration

You can tune options for transaction tracer in newrelic.yml:

```yml
transaction_tracer:
  # Transaction tracer is enabled by default. Set this to false to
  # turn it off. This feature is only available at the Professional
  # product level.
  enabled: true

  # Threshold in seconds for when to collect a transaction
  # trace. When the response time of a controller action exceeds
  # this threshold, a transaction trace will be recorded and sent to
  # New Relic. Valid values are any float value, or (default) "apdex_f",
  # which will use the threshold for an dissatisfying Apdex
  # controller action - four times the Apdex T value.
  transaction_threshold: apdex_f

  # When transaction tracer is on, SQL statements can optionally be
  # recorded. The recorder has three modes, "off" which sends no
  # SQL, "raw" which sends the SQL statement in its original form,
  # and "obfuscated", which strips out numeric and string literals.
  record_sql: obfuscated

  # Threshold in seconds for when to collect stack trace for a SQL
  # call. In other words, when SQL statements exceed this threshold,
  # then capture and send to New Relic the current stack trace. This is
  # helpful for pinpointing where long SQL calls originate from.
  stack_trace_threshold: 0.500

  # Threshold for query execution time below which query plans will not
  # not be captured.  Relevant only when `explain_enabled` is true.
  # explain_threshold: 0.5

  # When transaction tracer is on, SQL statements can optionally be
  # recorded. The recorder has three modes, "off" which sends no
  # SQL, "raw" which sends the SQL statement in its original form,
  # and "obfuscated", which strips out numeric and string literals.
  record_sql: obfuscated
```

## News

There's no official place for news & updates yet but you can follow @sbartholomew on Twitter for announcements.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
