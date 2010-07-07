
begin
  require 'jeweler'
  require 'bundler'
  Jeweler::Tasks.new do |gem|
    gem.name = "{{name}}"
    gem.summary = %Q{{{summary}}}
    gem.description = %Q{{{description}}}
    gem.email = "{{email}}"
    gem.homepage = "{{website}}"
    gem.authors = ["{{author}}"]
    
    # rdoc
    gem.has_rdoc = true
    gem.rdoc_options << '--title' << "{{name}}"
    gem.rdoc_options << '--line-numbers' << '--inline-source'
    
    gem.extra_rdoc_files += FileList['app/**/*.rb']
    
    # files
    included_files = FileList['lib/**/*.rb'] +
                     FileList['app/**/*.rb'] +
                     FileList['app/views/**/*'] +
                     FileList['rails/**/*.rb'] +
                     FileList['config/locales/*.{rb,yml}'] +
                     FileList['config/milkshake.yml'] +
                     FileList['config/routes.rb'] +
                     FileList['db/migrate/*.{rb}'] +
                     FileList['public/**/*']
    
    ignored_files  = FileList['public/{404,422,500}.html'] +
                     FileList['public/system/**/*'] +
                     FileList['lib/tasks/jeweler.rb']
    
    gem.files += (included_files - ignored_files)
    
    # runtime dependencies
    gem.add_bundler_dependencies
    
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
