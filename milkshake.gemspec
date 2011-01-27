# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "milkshake/version"

Gem::Specification.new do |s|
  s.name        = "milkshake"
  s.version     = Milkshake::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Simon Menke"]
  s.email       = ["simon.menke@gmail.com"]
  s.homepage    = "http://github.com/fd/milkshake"
  s.summary     = %q{Make composite rails applications}
  s.description = %q{Compose rails applications using several smaller rails applications}

  s.rubyforge_project = "milkshake"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency 'thor'
  s.add_runtime_dependency 'rack-gem-assets'
  
end
