
module Composite
  class Environment
    
    attr_reader :gems, :options, :cache
    
    def self.load(cache, path)
      if File.exist?(path)
        new cache, YAML.load_file(path)
      else
        new cache
      end
    end
    
    def initialize(cache, options={})
      @cache   = cache
      @options = {'gems' => {}}.merge(options)
      
      resolver  = nil
      @gems = @cache.key('environment.gems') do
        resolver ||= DependencyResolver.load_for(@options['gems'])
        resolver.gems
      end
      
      @gemspecs = @cache.key('environment.gemspecs') do
        resolver ||= DependencyResolver.load_for(@options['gems'])
        resolver.specs
      end
      
      @order = @cache.key('environment.gems.order') do
        resolver ||= DependencyResolver.load_for(@options['gems'])
        resolver.names
      end
    end
    
    def gemspecs_by_name
      @gemspecs ||= {}
    end
    
    def gemspecs
      gemspecs_by_name.values
    end
    
    def gem_dependencies
      @order.inject([]) do |g, name|
        g << Rails::GemDependency.new(name, @gems[name])
      end
    end
    
    def locale_paths
      @cache.key('environment.locale_paths') do
        if Gem::Version.new(Rails.version) < Gem::Version.new("2.3.4")
          locale_paths = self.gemspecs.inject([]) do |paths, gemspec|
            locale_path = File.join(gemspec.full_gem_path, 'config', 'locales')
            if File.directory?(locale_path)
              paths.push(Dir[File.join(locale_path, '*.{rb,yml}')])
            else
              paths
            end
          end
          locale_paths.flatten!
        else
          []
        end
      end
    end
    
  end
end
