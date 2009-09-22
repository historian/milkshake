
module Composite
  module RailsExtentions
    
    module VendorBoot
      def self.included(base)
        base.module_eval do
          alias_method :load_initializer_without_composite, :load_initializer
          alias_method :load_initializer, :load_initializer_with_composite
        end
      end
      
      def load_initializer_with_composite
        load_initializer_without_composite
        Composite.load!
        Composite.extender.extend_railties!
      end
    end
    
    module GemBoot
      def self.included(base)
        base.module_eval do
          alias_method :load_initializer_without_composite, :load_initializer
          alias_method :load_initializer, :load_initializer_with_composite
        end
      end
      
      def load_initializer_with_composite
        load_initializer_without_composite
        Composite.load!
        Composite.extender.extend_railties!
      end
    end
    
  end
end
