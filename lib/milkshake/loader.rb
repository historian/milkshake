
module Milkshake
  class Loader
    
    attr_accessor :environment, :cache
    
    def initialize(environment, cache)
      @environment = environment
      @cache       = cache
    end
    
    def load_gem_initializers!
      initializers.each do |initializer|
        load(initializer)
      end
    end
    
  private
    
    def initializers
      @cache.key('loader.initializers') do
        relative_path = ['rails', 'initializers', '**', '*.rb']
        self.environment.gemspecs.inject([]) do |paths, gemspec|
          paths.concat Dir.glob(File.join(gemspec.full_gem_path, *relative_path))
          paths
        end
      end
    end
    
  end
end

