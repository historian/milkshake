
module Milkshake
  module RailsExtentions
    module Initializer
      
      def self.included(base)
        %w( require_frameworks check_for_unbuilt_gems load_application_initializers process ).each do |m|
          base.send :alias_method, "#{m}_without_milkshake", m
          base.send :alias_method, m, "#{m}_with_milkshake"
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
      
      def process_with_milkshake
        process_without_milkshake
        
        stack = ActionController::Dispatcher.middleware
        unless stack.any? { |middleware| Rack::GemAssets === middleware }
          stack.insert_before(Rails::Rack::Metal, Rack::GemAssets)
        end
      rescue Exception => e
        Milkshake.cache.restore!
        Milkshake.environment.reload!
        if Milkshake.linker.current_snapshot
          Snapshots.load(Milkshake.linker.current_snapshot)
        end
        
        if @restore_relink
          raise e
        else
          @restore_relink = true
          retry
        end
      end
      
    end
  end
end
