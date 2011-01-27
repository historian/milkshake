
module Milkshake
  class Environment
    
    attr_reader :cache
    
    def initialize(cache)
      @cache = cache
      reload!
    end
    
    def reload!
      groups = [:default, Rails.env.to_s.to_sym]
      @gemspecs = Bundler.definition.specs_for(groups)
    end
    
    def gemspecs
      @gemspecs
    end
    
    def gem_dependencies
      @gemspecs.map do |spec|
        Rails::GemDependency.new(spec.name, :lib => false, :version => spec.version)
      end
    end
    
  end
end
