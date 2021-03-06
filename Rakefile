require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "milkshake"
    gem.summary = %Q{Make composite rails applications}
    gem.description = %Q{Compose rails applications using several smaller rails applications}
    gem.email = "simon@mrhenry.be"
    gem.homepage = "http://github.com/simonmenke/milkshake"
    gem.authors = ["Simon Menke"]
    gem.add_development_dependency "thoughtbot-shoulda"
    gem.add_development_dependency "yard"
    gem.add_runtime_dependency 'thor'
    gem.add_runtime_dependency 'snapshots'
    gem.add_runtime_dependency 'rack-gem-assets'
    gem.files += FileList['lib/**/*.rb'] + FileList['templates/**/*']
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
