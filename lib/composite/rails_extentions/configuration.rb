
module Composite
  module RailsExtentions
    module Configuration
      
      extend Composite::Utils::CompositeMethod
      composite_method :default_gems
      composite_method :default_i18n
      
      # inject gem dependecies
      def default_gems_with_composite
        default_gems = default_gems_without_composite
        default_gems.concat(Composite.environment.gem_dependencies)
        default_gems
      end
      
      # inject locales from gem dependecies
      def default_i18n_with_composite
        default_i18n = default_i18n_without_composite
        default_i18n.load_path.concat(Composite.environment.locale_paths)
        default_i18n.load_path.uniq!
        default_i18n
      end
      
    end
  end
end
