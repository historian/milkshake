
module Milkshake
  module RailsExtentions
    module Configuration
      
      extend Milkshake::Utils::MilkshakeMethod
      milkshake_method :default_gems
      milkshake_method :default_i18n
      
      # inject gem dependecies
      def default_gems_with_milkshake
        default_gems = default_gems_without_milkshake
        default_gems.concat(Milkshake.environment.gem_dependencies)
        default_gems
      end
      
      # inject locales from gem dependecies
      def default_i18n_with_milkshake
        default_i18n = default_i18n_without_milkshake
        default_i18n.load_path.concat(Milkshake.environment.locale_paths)
        default_i18n.load_path.uniq!
        default_i18n
      end
      
    end
  end
end
