
module Milkshake
  class Environment

    def gemspecs
      load_gemspecs
      @gemspecs
    end

    def gem_dependencies
      load_gemspecs
      @gemspecs.map do |spec|
        Rails::GemDependency.new(spec.name, :lib => false, :version => spec.version)
      end
    end

  private

    def load_gemspecs
      return if @gemspecs

      groups = [:default, RAILS_ENV.to_sym]
      @gemspecs = Bundler.definition.specs_for(groups)
    end

  end
end
