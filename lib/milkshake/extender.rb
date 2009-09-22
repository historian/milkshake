
module Milkshake
  class Extender
    
    def inject_milkshake!
      if defined?(::PhusionPassenger)
        extend_rails!
      else
        extend_boot!
      end
      extend_rubygems!
    end
    
    # for passenger
    def extend_rails!
      Object.const_set('Rails', Module.new)
      r = Object.const_get('Rails')
      def r.singleton_method_added(m)
        if (m.to_s == 'boot!') and !@injected_milkshake
          @injected_milkshake = true
          k = (class << self ; self ; end)
          k.send :alias_method, "milkshakeless_#{m}", m
          k.send :define_method, m do
            milkshakeless_boot!
            Milkshake.load!
            Milkshake.extender.extend_railties!
          end
        end
      end
    end
    
    # for others
    def extend_boot!
      include_module Rails::VendorBoot, Milkshake::RailsExtentions::VendorBoot
      include_module Rails::GemBoot,    Milkshake::RailsExtentions::GemBoot
    end
    
    def extend_railties!
      include_module Rails::Configuration, Milkshake::RailsExtentions::Configuration
      include_module Rails::Initializer,   Milkshake::RailsExtentions::Initializer
    end
    
    def extend_frameworks!
      include_module ActiveRecord::Migrator, Milkshake::RailsExtentions::Migrator
    end
    
    def extend_rubygems!
      include_module Gem::Specification, Milkshake::RubygemsExtentions::Specification
    end
    
  private
    
    def include_module(base, mod)
      unless base.included_modules.include?(mod)
        base.send :include, mod
      end
    end
    
  end
end
