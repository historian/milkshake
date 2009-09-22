
module Composite
  module Utils
    module CompositeMethod
      
      def included(base)
        composite_methods.each do |m|
          if !base.instance_methods.include?(m) and !base.instance_methods.include?(m.to_sym)
            base.send :alias_method, "#{m}_without_composite", m
            base.send :alias_method, m, "#{m}_with_composite"
          end
        end
      end
      
      def method_added(m)
        if composite_methods.include?(m.to_s)
          alias_method "#{m}_without_composite", m
          alias_method m, "#{m}_with_composite"
        end
      end
      
      def composite_methods
        @composite_methods ||= []
      end
      
      def composite_method(m)
        composite_methods.push(m.to_s) unless composite_methods.include?(m.to_s)
      end
      
    end
  end
end
