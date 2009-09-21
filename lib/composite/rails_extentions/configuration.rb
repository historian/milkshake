
module Composite
  module RailsExtentions
    module Configuration
      
      def self.included(base)
        base.module_eval do
          alias_method :default_gems_without_composite, :default_gems
          alias_method :default_gems, :default_gems_with_composite
        end
      end
      
      def default_gems_with_composite
        default_gems = default_gems_without_composite
        default_gems.concat(Composite.environment.gem_dependencies)
        default_gems
      end
      
    end
  end
end
