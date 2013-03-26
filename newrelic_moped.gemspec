# -*- encoding: utf-8 -*-
require File.expand_path('../lib/newrelic_moped/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Stephen Bartholomew"]
  gem.email         = ["stephenbartholomew@gmail.com"]
  gem.description   = %q{New Relic Instrumentation for Moped & Mongoid 3}
  gem.summary   = %q{New Relic Instrumentation for Moped & Mongoid 3}
  gem.homepage      = ""

  gem.files         = Dir["{lib}/**/*.rb", "LICENSE", "*.md"]
  gem.name          = "newrelic_moped"
  gem.require_paths = ["lib"]
  gem.version       = NewrelicMoped::VERSION
  gem.add_dependency 'newrelic_rpm', '~> 3.6.0'
  gem.add_dependency 'moped'

  gem.add_development_dependency 'rake'
end
