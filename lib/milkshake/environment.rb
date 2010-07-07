
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
      
      reload!
    end
    
    def reload!
      %x[bundle lock]
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
