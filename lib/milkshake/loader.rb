
module Milkshake
  class Loader

    attr_accessor :environment

    def initialize(environment)
      @environment = environment
    end

    def load_gem_initializers!
      initializers.each do |initializer|
        load(initializer)
      end
    end

  private

    def initializers
      relative_path = 'rails/initializers/**/*.rb'
      paths = []

      self.environment.gemspecs.each do |gemspec|
        pattern = File.expand_path(relative_path, gemspec.full_gem_path)
        paths.concat Dir.glob(pattern)
      end

      paths.concat Dir.glob(File.join(Rails.root, 'rails/init.rb'))
      paths.concat Dir.glob(File.join(Rails.root, relative_path))

      paths
    end

  end
end

