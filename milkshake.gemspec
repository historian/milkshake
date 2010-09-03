# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'milkshake/version'

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

  s.executables = ["milkshake"]
  s.default_executable = "milkshake"

  s.files        = Dir.glob("{app,lib,templates,milkshake}/**/*") + %w(LICENSE README.md)
  s.require_path = 'lib'

  s.add_runtime_dependency 'opts',    '~> 0.0'
  s.add_runtime_dependency 'bundler', '~> 1.0'

end
