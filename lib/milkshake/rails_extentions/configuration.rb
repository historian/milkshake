
module Milkshake
  module RailsExtentions
    module Configuration
      
      def self.included(base)
        %w( default_gems default_i18n default_load_paths ).each do |meth|
          base.send :alias_method, "#{meth}_without_milkshake", meth
          base.send :alias_method, meth, "#{meth}_with_milkshake"
        end
      end
      
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
      
      # inject fallback application controller
      def default_load_paths_with_milkshake
        path = File.expand_path(File.join(File.dirname(__FILE__), *%w( .. rails_fallbacks )))
        default_load_paths_without_milkshake.push(path)
      end
      
    end
  end
end
