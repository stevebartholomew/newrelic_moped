# -*- encoding: utf-8 -*-
require File.expand_path('../lib/newrelic_moped/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Stephen Bartholomew"]
  gem.email         = ["stephenbartholomew@gmail.com"]
  gem.description   = %q{New Relic Instrumentation for Moped & Mongoid 3}
  gem.summary   = %q{New Relic Instrumentation for Moped & Mongoid 3}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "newrelic_moped"
  gem.require_paths = ["lib"]
  gem.version       = NewrelicMoped::VERSION
end
