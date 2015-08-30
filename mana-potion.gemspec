# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mana-potion/version'

Gem::Specification.new do |spec|
  spec.name          = "mana-potion"
  spec.version       = ManaPotion::VERSION
  spec.authors       = ["mrodrigues"]
  spec.email         = ["mrodrigues.uff@gmail.com"]

  spec.summary       = %q{Do you need to limit some resource's creation rate? It's simple to do it with `ManaPotion`!}
  spec.description   = %q{
    The ManaPotion gem helps you validate any ActiveRecord::Base 
    model so that no user will be able to create it faster than some 
    given limit. Really useful when you're using an expensive API and 
    don't want some user to bankrupt you.
  }
  spec.homepage      = "https://github.com/mrodrigues/mana-potion"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.9"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "pry", ">= 0.10.1"
  spec.add_development_dependency "rspec", ">= 3.3.0"
  spec.add_development_dependency "activerecord", ">= 4.2.4"
  spec.add_development_dependency "sqlite3", ">= 1.3.10"
  spec.add_development_dependency "timecop", ">= 0.7.1"
end
