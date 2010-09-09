# -*- encoding: utf-8 -*-
require File.expand_path("../lib/milkshake/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "milkshake"
  s.version     = Milkshake::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Simon Menke"]
  s.email       = ["simon.menke@gmail.com"]
  s.homepage    = "http://github.com/fd/milkshake"
  s.summary     = "Make composite rails applications"
  s.description = "Compose rails applications using several smaller rails applications"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "milkshake"

  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'

  s.add_runtime_dependency 'opts',    '~> 0.0'
  s.add_runtime_dependency 'bundler', '~> 1.0'
end
