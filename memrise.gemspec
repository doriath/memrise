# -*- encoding: utf-8 -*-
require File.expand_path('../lib/memrise/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tomasz Zurkowski"]
  gem.email         = ["doriath88@gmail.com"]
  gem.description   = %q{Memrise API wrapper}
  gem.summary       = %q{API wrapper for the www.memrise.com}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "memrise"
  gem.require_paths = ["lib"]
  gem.version       = Memrise::VERSION

  gem.add_development_dependency('rake')
  gem.add_development_dependency('rspec', '~> 2')
  gem.add_development_dependency('guard')
  gem.add_development_dependency('guard-rspec')
  gem.add_development_dependency('rb-readline')
end
