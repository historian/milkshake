module Milkshake::RailsExt::Initializer
  
  def self.included(base)
    base.class_eval do
      
      old_m = :load_application_initializers_without_milkshake
      unless instance_methods.include?(old_m.to_s)
        alias_method old_m, :load_application_initializers
      end
      
    end
  end
  
  def load_gems
    @bundler_loaded ||= Bundler.require :default, Rails.env
  end
  
  def load_application_initializers
    Milkshake::Linker.new.link!
    
    paths = []
    
    Bundler::SPECS.each do |gemspec|
      paths.concat Dir.glob(File.expand_path(
        'rails/initializers/**/*.rb',
        gemspec.full_gem_path))
    end
    
    paths.concat Dir.glob(File.expand_path(
      'rails/initializers/**/*.rb',
      Rails.root))
      
    Bundler::SPECS.each do |gemspec|
      paths.concat Dir.glob(File.expand_path(
        'rails/init.rb',
        gemspec.full_gem_path))
    end
    
    paths.concat Dir.glob(File.expand_path(
      'rails/init.rb',
      Rails.root))
    
    paths.each do |path|
      load(path)
    end
    
    load_application_initializers_without_milkshake
  end
  
end
