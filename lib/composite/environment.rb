
module Composite
  class Environment
    
    attr_reader :gems, :options
    
    def self.load(path)
      if File.exist?(path)
        new YAML.load_file(path)
      else
        new
      end
    end
    
    def initialize(options={})
      @options = {'gems' => {}}.merge(options)
      @gems = {}
      add_configured_gems
      add_dependencies
    end
    
    def gem(name, options={})
      options = options.inject({}) do |m, (k, v)|
        m[k.to_sym] = v
        m
      end
      @gems[name.to_s] = options
    end
    
    def gemspecs_by_name
      @gemspecs ||= {}
    end
    
    def gemspecs
      gemspecs_by_name.values
    end
    
    def gem_dependencies
      @gems.inject([]) do |g, (name, options)|
        g << Rails::GemDependency.new(name, options)
      end
    end
    
  private
    
    def add_configured_gems
      @options['gems'].each do |name, options|
        self.gem(name, options)
      end
    end
    
    def add_dependencies
      lookedup     = []
      needs_lookup = @gems.keys
      needs_lookup.each do |name|
        next if lookedup.include?(name.to_s)
        options = @gems[name]
        
        spec = find_gemspec(name, options)
        lookedup.push(name.to_s)
        (spec.engine_dependencies || []).each do |name, options|
          unless @gems.key?(name.to_s)
            self.gem(name, options)
            needs_lookup.push(name.to_s)
          end
        end
      end
    end
    
    def find_gemspec(name, options={})
      return self.gemspecs_by_name[name.to_s] if self.gemspecs_by_name[name.to_s]
      
      requirement = options[:version] || Gem::Requirement.default
      dep   = Gem::Dependency.new(name, requirement)
      specs = gemspec_index.search(dep)
      
      return nil if specs.empty?
      
      specs.sort! do |a,b|
        b.version <=> a.version
      end
      
      gemspec = specs.first
      self.gemspecs_by_name[name.to_s] = gemspec
      
      gemspec
    end
    
    def gemspec_index
      @gemspec_index ||= Gem::SourceIndex.from_installed_gems
    end
    
  end
end
