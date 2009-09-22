
module Composite
  module RailsExtentions
    module Initializer
      
      extend Composite::Utils::CompositeMethod
      composite_method :require_frameworks
      composite_method :load_application_initializers
      
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
