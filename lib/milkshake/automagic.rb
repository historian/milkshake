module Rails
  class BundlerBoot
    def run
      load_initializer
    
      Rails::Initializer.class_eval do
        def load_gems
          @bundler_loaded ||= Bundler.require :default, Rails.env
        end
        
        alias_method :load_application_initializers_without_milkshake, :load_application_initializers
        
        def load_application_initializers
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
    
      Rails::Initializer.run(:set_load_path)
    end
    
    def load_initializer
      unless defined? PhusionPassenger
        load_bundler
        setup_load_paths
      end
      
      setup_app_load_path
      
      require 'initializer'
    end
    
    def load_bundler
      begin
        require 'rubygems'
        require 'bundler'
      rescue LoadError
        raise "Could not load the bundler gem. " +
          "Install it with `gem install bundler`."
      end
      
      if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.24")
        raise RuntimeError, "Your bundler version is too old. " +
          "Run `gem install bundler` to upgrade."
      end
      
      true
    end
    
    def setup_load_paths
      # Set up load paths for all bundled gems
      ENV["BUNDLE_GEMFILE"] = File.expand_path("#{RAILS_ROOT}/Gemfile", __FILE__)
      Bundler.setup
    rescue Bundler::GemNotFound
      raise RuntimeError, "Bundler couldn't find some gems. " +
        "Did you run `bundle install`?"
    end
    
    def setup_app_load_path
      Bundler::SPECS.each do |gemspec|
        gem_path = gemspec.full_gem_path
        idx = $:.index(File.expand_path('lib', gem_path))
        
        load_path = File.expand_path('app', gem_path)
        $:.insert(idx, load_path) if File.directory?(load_path)
        
        load_path = File.expand_path('app/models', gem_path)
        $:.insert(idx, load_path) if File.directory?(load_path)
        
        load_path = File.expand_path('app/helpers', gem_path)
        $:.insert(idx, load_path) if File.directory?(load_path)
        
        load_path = File.expand_path('app/controllers', gem_path)
        $:.insert(idx, load_path) if File.directory?(load_path)
        
        load_path = File.expand_path('app/metal', gem_path)
        $:.insert(idx, load_path) if File.directory?(load_path)
      end
    end
    
  end
  
  def self.pick_boot
    BundlerBoot.new
  end
end