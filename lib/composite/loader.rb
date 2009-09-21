
module Composite
  class Loader
    
    attr_accessor :environment
    
    def initialize(environment)
      @environment = environment
    end
    
    def load_gem_initializers!
      self.environment.gemspecs.each do |gemspec|
        initializers_path = File.join(gemspec.full_gem_path, 'rails', 'initializers', '**', '*.rb')
        Dir.glob(initializers_path).each do |initializer|
          load(initializer)
        end
      end
    end
    
  end
end

