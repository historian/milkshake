
module Milkshake
  module RailsExtentions
    module Initializer
      
      extend Milkshake::Utils::MilkshakeMethod
      milkshake_method :require_frameworks
      milkshake_method :load_application_initializers
      
      def require_frameworks_with_milkshake
        require_frameworks_without_milkshake
        Milkshake.extender.extend_frameworks!
      end
      
      def load_application_initializers_with_milkshake
        Milkshake.linker.link!
        if gems_dependencies_loaded
          Milkshake.loader.load_gem_initializers!
          Milkshake.persist!
        end
        load_application_initializers_without_milkshake
      end
      
    end
  end
end
