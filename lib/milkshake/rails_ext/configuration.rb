module Milkshake::RailsExt::Configuration
  
  def self.included(base)
    base.class_eval do
      
      old_m = :default_i18n_without_milkshake
      unless instance_methods.include?(old_m.to_s)
        alias_method old_m, :default_i18n
      end
      
    end
  end
  
  # inject locales from gem dependecies
  def default_i18n
    i18n = default_i18n_without_milkshake
    
    paths = []
    
    Bundler::SPECS.each do |gemspec|
      locale_dir = File.expand_path(
        'config/locales',
        gemspec.full_gem_path))
      
      if File.directory?(locale_dir)
        paths.concat Dir[File.join(locale_path, '*.{rb,yml}')]
      end
    end
    
    i18n.load_path.concat(paths)
    i18n.load_path.uniq!
    
    i18n
  end
  
end
