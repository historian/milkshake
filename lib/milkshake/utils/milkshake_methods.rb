
module Milkshake
  module Utils
    module MilkshakeMethod
      
      def included(base)
        milkshake_methods.each do |m|
          if !base.instance_methods.include?(m) and !base.instance_methods.include?(m.to_sym)
            base.send :alias_method, "#{m}_without_milkshake", m
            base.send :alias_method, m, "#{m}_with_milkshake"
          end
        end
      end
      
      def method_added(m)
        if milkshake_methods.include?(m.to_s)
          alias_method "#{m}_without_milkshake", m
          alias_method m, "#{m}_with_milkshake"
        end
      end
      
      def milkshake_methods
        @milkshake_methods ||= []
      end
      
      def milkshake_method(m)
        milkshake_methods.push(m.to_s) unless milkshake_methods.include?(m.to_s)
      end
      
    end
  end
end
