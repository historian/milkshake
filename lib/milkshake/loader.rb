
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
        relative_path = %w( rails initializers ** *.rb )
        paths = []
        self.environment.gemspecs.each do |gemspec|
          paths.concat Dir.glob(File.join(gemspec.full_gem_path, *relative_path))
        end
        rails_root = Rails.root
        paths.concat Dir.glob(File.join(rails_root, 'rails/init.rb'))
        paths.concat Dir.glob(File.join(rails_root, *relative_path))
        paths
      end
    end
    
  end
end

