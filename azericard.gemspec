# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'azericard/version'

Gem::Specification.new do |spec|
  spec.name          = "azericard"
  spec.version       = Azericard::VERSION
  spec.authors       = ["Nihad Abbasov"]
  spec.email         = ["mail@narkoz.me"]
  spec.description   = "Provides an interface to AzeriCard online payment processing system"
  spec.summary       = "Unoffical gem to provide a ruby interface for Azericard electronic payment system"
  spec.homepage      = "https://github.com/narkoz/azericard"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'typhoeus'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
end
