# -*- encoding: utf-8 -*-
require File.expand_path('../lib/newrelic_moped/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Stephen Bartholomew", "Piotr Sokolowski"]
  gem.email         = ["stephenbartholomew@gmail.com"]
  gem.description   = %q{New Relic Instrumentation for Moped & Mongoid 3}
  gem.summary       = %q{New Relic Instrumentation for Moped & Mongoid 3}
  gem.homepage      = "https://github.com/stevebartholomew/newrelic_moped"
  gem.license       = "MIT"

  gem.files         = Dir["{lib}/**/*.rb", "LICENSE", "*.md"]
  gem.name          = "newrelic_moped"
  gem.require_paths = ["lib"]
  gem.version       = NewrelicMoped::VERSION
  gem.post_install_message = <<-MESSAGE
----------------
IMPORTANT!

This is the last version of newrelic_moped
supporting newrelic_rpm version < 3.11 !

----------------
  MESSAGE

  gem.add_dependency 'newrelic_rpm', '>= 3.7', '< 3.11'
  gem.add_dependency 'moped'

  gem.add_development_dependency 'rake'
end
