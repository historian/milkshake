
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "{{name}}"
    gem.summary = %Q{{{summary}}}
    gem.description = %Q{{{description}}}
    gem.email = "{{email}}"
    gem.homepage = "{{website}}"
    gem.authors = ["{{author}}"]
    
    # development dependencies
    gem.add_development_dependency "milkshake"
    gem.add_development_dependency "thoughtbot-shoulda"
    
    # rdoc
    gem.has_rdoc = true
    gem.rdoc_options << '--title' << "{{name}}"
    gem.rdoc_options << '--line-numbers' << '--inline-source'
    
    included_files = FileList['app/**/*.rb']
    
    ignored_files  = FileList['app/controllers/application_controller.rb'] +
                     FileList['app/helpers/application_helper.rb']
    
    gem.extra_rdoc_files += (included_files - ignored_files)
    
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
    
    ignored_files  = FileList['app/controllers/application_controller.rb'] +
                     FileList['app/helpers/application_helper.rb'] +
                     FileList['public/{404,422,500}.html'] +
                     FileList['public/vendor/**/*'] +
                     FileList['public/system/**/*']
    
    gem.files += (included_files - ignored_files)
    
    # runtime dependencies
    milkshake_config = YAML.load_file('config/milkshake.yml')
    milkshake_config['gems'].each do |name, options|
      gem.add_runtime_dependency(name, (options['version'] || Gem::Requirement.default))
    end
    
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
