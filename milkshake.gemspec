# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{milkshake}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Simon Menke"]
  s.date = %q{2009-09-22}
  s.default_executable = %q{milkshake}
  s.description = %q{Compose rails applications using several smaller rails applicatons}
  s.email = %q{simon@mrhenry.be}
  s.executables = ["milkshake"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/milkshake",
     "milkshake.gemspec",
     "lib/milkshake.rb",
     "lib/milkshake.rb",
     "lib/milkshake/app.rb",
     "lib/milkshake/app.rb",
     "lib/milkshake/automagic.rb",
     "lib/milkshake/automagic.rb",
     "lib/milkshake/cache.rb",
     "lib/milkshake/cache.rb",
     "lib/milkshake/dependency_resolver.rb",
     "lib/milkshake/dependency_resolver.rb",
     "lib/milkshake/environment.rb",
     "lib/milkshake/environment.rb",
     "lib/milkshake/extender.rb",
     "lib/milkshake/extender.rb",
     "lib/milkshake/linker.rb",
     "lib/milkshake/linker.rb",
     "lib/milkshake/loader.rb",
     "lib/milkshake/loader.rb",
     "lib/milkshake/rails_extentions/boot.rb",
     "lib/milkshake/rails_extentions/boot.rb",
     "lib/milkshake/rails_extentions/configuration.rb",
     "lib/milkshake/rails_extentions/configuration.rb",
     "lib/milkshake/rails_extentions/initializer.rb",
     "lib/milkshake/rails_extentions/initializer.rb",
     "lib/milkshake/rails_extentions/migrations.rb",
     "lib/milkshake/rails_extentions/migrations.rb",
     "lib/milkshake/rubygems_extentions/specification.rb",
     "lib/milkshake/rubygems_extentions/specification.rb",
     "lib/milkshake/template.rb",
     "lib/milkshake/template.rb",
     "lib/milkshake/utils/milkshake_methods.rb",
     "lib/milkshake/utils/milkshake_methods.rb",
     "lib/milkshake/validator.rb",
     "lib/milkshake/validator.rb",
     "templates/milkshake.yml",
     "templates/milkshake.yml",
     "templates/jeweler.rake",
     "templates/jeweler.rake",
     "templates/preinitializer.rb",
     "templates/preinitializer.rb",
     "templates/routes.rb",
     "test/milkshake_test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/simonmenke/milkshake}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Make milkshake rails applications}
  s.test_files = [
    "test/milkshake_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_runtime_dependency(%q<thor>, [">= 0"])
      s.add_runtime_dependency(%q<snapshots>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<thor>, [">= 0"])
      s.add_dependency(%q<snapshots>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<thor>, [">= 0"])
    s.add_dependency(%q<snapshots>, [">= 0"])
  end
end
