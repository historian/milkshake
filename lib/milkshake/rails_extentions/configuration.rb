
module Milkshake
  module RailsExtentions
    module Configuration
      
      def self.included(base)
        %w( default_gems default_load_paths ).each do |meth|
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
      
      # inject fallback application controller
      def default_load_paths_with_milkshake
        Milkshake.environment.gemspecs.each do |gemspec|
          app_path = File.join(gemspec.full_gem_path, 'app', 'controllers', 'application_controller.rb')
          if File.file?(app_path)
            return default_load_paths_without_milkshake
          end
        end
        
        path = File.expand_path(File.join(File.dirname(__FILE__), *%w( .. rails_fallbacks )))
        default_load_paths_without_milkshake.push(path)
      end
      
    end
  end
end
