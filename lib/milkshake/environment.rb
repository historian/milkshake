
module Milkshake
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
      @options['gems']['rack-gem-assets'] = { 'lib' => 'rack/gem_assets' }
      
      Milkshake.extender.extend_rubygems!
      
      reload!
    end
    
    def reload!
      resolver  = nil
      index = Gem::SourceIndex.from_installed_gems
      
      @gems = @cache.key('environment.gems') do
        resolver ||= DependencyResolver.load_for(@options['gems'])
        resolver.gems
      end
      
      @gemspecs = nil
      @gemspec_versions = @cache.key('environment.gemspec-versions') do
        resolver ||= DependencyResolver.load_for(@options['gems'])
        specs = resolver.specs
        @gemspecs = specs
        specs.inject({}) { |memo, (name, spec)| memo[name] = spec.version.to_s ; memo  }
      end
      
      @gemspecs ||= @gemspec_versions.inject({}) do |memo, (name, version)|
        specs = index.search(Gem::Dependency.new(name, version))
        specs.sort! do |left,right|
          right.version <=> left.version
        end
        memo[name] = specs.first
        memo
      end
      
      @order = @cache.key('environment.gems.order') do
        resolver ||= DependencyResolver.load_for(@options['gems'])
        resolver.names
      end
      
      @ordered_gemspecs = nil
    end
    
    def gemspecs_by_name
      @gemspecs ||= {}
    end
    
    def gemspecs
      @ordered_gemspecs ||= @order.collect do |name|
        gemspecs_by_name[name]
      end.compact
    end
    
    def gem_dependencies
      @order.inject([]) do |deps, name|
        options = @gems[name].inject({}) do |memo, (key, value)|
          memo[key.to_sym] = value
          memo
        end
        deps << Rails::GemDependency.new(name, options)
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
