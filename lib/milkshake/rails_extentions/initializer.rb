
module Milkshake
  module RailsExtentions
    module Initializer

      def self.included(base)
        %w( require_frameworks load_application_initializers ).each do |meth|
          base.send :alias_method, "#{meth}_without_milkshake", meth
          base.send :alias_method, meth, "#{meth}_with_milkshake"
        end
      end

      def require_frameworks_with_milkshake
        require_frameworks_without_milkshake
        Milkshake.extender.extend_frameworks!
      end

      def load_application_initializers_with_milkshake
        Milkshake.loader.load_gem_initializers!
        load_application_initializers_without_milkshake
      end

    end
  end
end
