# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coffee-rails-source-maps/version'

Gem::Specification.new do |gem|
  gem.name          = "coffee-rails-source-maps"
  gem.version       = CoffeeRailsSourceMaps::VERSION
  gem.authors       = ["Mark Bates"]
  gem.email         = ["mark@markbates.com"]
  gem.description   = %q{Adds support to Rails for CoffeeScript Source Maps}
  gem.summary       = %q{Adds support to Rails for CoffeeScript Source Maps}
  gem.homepage      = ""
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("coffee-script-source", ">= 1.6.1")
  gem.add_development_dependency "rake"
end
