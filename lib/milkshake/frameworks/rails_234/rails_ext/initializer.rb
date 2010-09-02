class Rails::Initializer

  def load_gems
    @bundler_loaded ||= Bundler.require :default, Rails.env
  end

  alias \
    load_application_initializers_without_milkshake \
    load_application_initializers
  def load_application_initializers
    ActiveRecord::Migrator.send :include, Milkshake::RailsExtentions::Migrator
    
    
    paths = []

    Bundler.definition.specs.collect do |spec|
      paths.concat Dir.glob(File.expand_path(
        'rails/initializers/**/*.rb',
        spec.full_gem_path))
    end

    paths.concat Dir.glob(File.expand_path('rails/initializers/**/*.rb',
                                           Rails.root))

    paths.concat Dir.glob(File.expand_path('rails/init.rb',
                                           Rails.root))

    paths.concat Dir.glob(File.expand_path('settings/init.rb',
                                           Rails.root))

    paths.each do |path|
      load(path)
    end

    load_application_initializers_without_milkshake
  end

end
