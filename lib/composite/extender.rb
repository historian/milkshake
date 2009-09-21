
module Composite
  class Extender
    
    attr_reader :environment
    
    def initialize(environment)
      @environment = environment
    end
    
    def extend_boot!
      Rails::VendorBoot.send :include, Composite::RailsExtentions::VendorBoot
      Rails::GemBoot.send    :include, Composite::RailsExtentions::GemBoot
    end
    
    def extend_railties!
      Rails::Configuration.send :include, Composite::RailsExtentions::Configuration
      Rails::Initializer.send   :include, Composite::RailsExtentions::Initializer
    end
    
    def extend_frameworks!
      ActiveRecord::Migrator.send :include, Composite::RailsExtentions::Migrator
    end
    
  end
end
