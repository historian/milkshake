
module Composite
  module RailsExtentions
    module Initializer
      
      def self.included(base)
        base.module_eval do
          alias_method :require_frameworks_without_composite, :require_frameworks
          alias_method :require_frameworks, :require_frameworks_with_composite
          
          alias_method :load_application_initializers_without_composite, :load_application_initializers
          alias_method :load_application_initializers, :load_application_initializers_with_composite
        end
      end
      
      def require_frameworks_with_composite
        require_frameworks_without_composite
        Composite.extender.extend_frameworks!
      end
      
      def load_application_initializers_with_composite
        Composite.linker.link!
        if gems_dependencies_loaded
          Composite.loader.load_gem_initializers!
          Composite.persist!
        end
        load_application_initializers_without_composite
      end
      
    end
  end
end
