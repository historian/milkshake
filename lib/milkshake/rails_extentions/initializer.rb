
module Milkshake
  module RailsExtentions
    module Initializer
      
      def self.included(base)
        %w( require_frameworks check_for_unbuilt_gems load_application_initializers ).each do |meth|
          base.send :alias_method, "#{meth}_without_milkshake", meth
          base.send :alias_method, meth, "#{meth}_with_milkshake"
        end
      end
      
      def require_frameworks_with_milkshake
        require_frameworks_without_milkshake
        Milkshake.extender.extend_frameworks!
      end
      
      def check_for_unbuilt_gems_with_milkshake
        check_for_unbuilt_gems_without_milkshake
        
        Milkshake.linker.link!
      end
      
      def load_application_initializers_with_milkshake
        Milkshake.loader.load_gem_initializers!
        Milkshake.persist!
        
        load_application_initializers_without_milkshake
      end
      
      def load_gems
        @bundler_loaded ||= Bundler.require :default, Rails.env
      end
      
    end
  end
end
