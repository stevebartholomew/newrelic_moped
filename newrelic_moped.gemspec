# -*- encoding: utf-8 -*-
require File.expand_path('../lib/newrelic_moped/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Stephen Bartholomew", "Piotr Sokolowski"]
  gem.email         = ["stephenbartholomew@gmail.com"]
  gem.description   = %q{New Relic instrumentation for Moped (1.x, 2.0) / Mongoid (3.x, 4.0)}
  gem.summary       = %q{New Relic instrumentation for Moped (1.x, 2.0) / Mongoid (3.x, 4.0)}
  gem.homepage      = "https://github.com/stevebartholomew/newrelic_moped"
  gem.license       = "MIT"

  gem.files         = Dir["{lib}/**/*.rb", "LICENSE", "*.md"]
  gem.name          = "newrelic_moped"
  gem.require_paths = ["lib"]
  gem.version       = NewrelicMoped::VERSION
  gem.add_dependency 'newrelic_rpm', '>= 3.11'
  gem.add_dependency 'moped'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'test-unit'
end
