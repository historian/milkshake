
require 'tsort'

module Milkshake
  class DependencyResolver
    
    attr_reader :names, :specs, :gems
    
    def self.load_for(gems)
      dependency_loader = self.new(gems)
      dependency_loader.add_dependecies!
      dependency_loader.order_by_dependecies!
      return dependency_loader
    end
    
    def initialize(gems)
      specs = gems.collect do |name,options|
        find_gemspec(name,options)
      end.compact
      
      @names = specs.collect { |spec| spec.name }
      @specs = specs.inject({}) { |memo, spec| memo[spec.name] = spec ; memo }
      @gems  = gems
    end
    
    def add_dependecies!
      @specs.values.each do |spec|
        add_dependecies_for spec
      end
    end
    
    def order_by_dependecies!
      @names = tsort
    end
    
    def each
      @names.each do |name|
        yield(@specs[name])
      end
    end
    
    def reverse_each
      @names.reverse.each do |name|
        yield(@specs[name])
      end
    end
    
  private
    
    def find_gemspec(name, options={})
      requirement = options[:version] || options["version"] || Gem::Requirement.default
      dep   = Gem::Dependency.new(name, requirement)
      specs = gemspec_index.search(dep)
      
      if specs.empty?
        raise "Failed to resolve dependency: #{name} #{options.inspect}"
      end
      
      specs.sort! do |left,right|
        right.version <=> left.version
      end
      
      gemspec = specs.first
      
      gemspec
    end
    
    def gemspec_index
      @gemspec_index ||= Gem::SourceIndex.from_installed_gems
    end
    
    include TSort
    
    def add_dependecies_for(spec)
      deps = (spec.rails_dependencies || {})
      deps.each do |name, options|
        next if @names.include?(name)
        
        gemspec = find_gemspec(name, options)
        @specs[gemspec.name] = gemspec
        @names.push(gemspec.name)
        add_dependecies_for(gemspec)
      end
      
      @gems = @gems.merge(deps)
    end
    
    def tsort_each_node(&block)
      @names.each(&block)
    end
    
    def tsort_each_child(node, &block)
      deps = (@specs[node].rails_dependencies || {})
      deps.keys.each(&block)
    end
    
  end
end
