
module Milkshake
  module RailsExtentions

    module VendorBoot
      def self.included(base)
        base.module_eval do
          alias_method :load_initializer_without_milkshake, :load_initializer
          alias_method :load_initializer, :load_initializer_with_milkshake
        end
      end

      def load_initializer_with_milkshake
        load_initializer_without_milkshake
        Milkshake.load!
        Milkshake.extender.extend_railties!
      end
    end

    module GemBoot
      def self.included(base)
        base.module_eval do
          alias_method :load_initializer_without_milkshake, :load_initializer
          alias_method :load_initializer, :load_initializer_with_milkshake
        end
      end

      def load_initializer_with_milkshake
        load_initializer_without_milkshake
        Milkshake.load!
        Milkshake.extender.extend_railties!
      end
    end

  end
end
