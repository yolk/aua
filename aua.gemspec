# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "aua/version"

Gem::Specification.new do |s|
  s.name        = "aua"
  s.version     = Aua::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Sebastian Munz"]
  s.email       = ["sebastian@yo.lk"]
  s.license     = 'MIT'
  s.homepage    = "https://github.com/yolk/aua"
  s.summary     = %q{aua = a user agent (parser).}
  s.description = %q{aua = a user agent (parser).}

  s.rubyforge_project = "aua"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec',       '~>2.4'
  s.add_development_dependency 'guard-rspec', '>=3.0'
  s.add_development_dependency 'growl',       '>=1.0'
  s.add_development_dependency 'rb-fsevent',  '>=0.9'
end
