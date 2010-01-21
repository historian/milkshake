
require 'fileutils'

module Milkshake
  
  RAILS_VERSION = "2.3.4"
  
  autoload :DependencyResolver, 'milkshake/dependency_resolver'
  autoload :Environment,        'milkshake/environment'
  autoload :Validator,          'milkshake/validator'
  autoload :Template,           'milkshake/template'
  autoload :Extender,           'milkshake/extender'
  autoload :Linker,             'milkshake/linker'
  autoload :Loader,             'milkshake/loader'
  autoload :Cache,              'milkshake/cache'
  autoload :App,                'milkshake/app'
  
  module RailsExtentions
    autoload :Configuration, 'milkshake/rails_extentions/configuration'
    autoload :Initializer,   'milkshake/rails_extentions/initializer'
    autoload :Migrator,      'milkshake/rails_extentions/migrations'
    autoload :GemBoot,       'milkshake/rails_extentions/boot'
    autoload :VendorBoot,    'milkshake/rails_extentions/boot'
  end
  
  module RubygemsExtentions
    autoload :Specification, 'milkshake/rubygems_extentions/specification'
  end
  
  class << self
    attr_accessor :configuration_file
    attr_accessor :cache_file
    
    def load!
      cache
      validator
      environment
      loader
      linker
      extender
    end
    
    def environment
      self.configuration_file ||= File.join(RAILS_ROOT, 'config', 'milkshake.yml')
      @environment ||= Environment.load(self.cache, self.configuration_file)
    end
    
    def validator
      @validator ||= Validator.new(self.cache)
    end
    
    def loader
      @loader ||= Loader.new(self.environment, self.cache)
    end
    
    def linker
      @linker ||= Linker.new(self.environment, self.validator, self.cache)
    end
    
    def extender
      @extender ||= Extender.new
    end
    
    def cache
      @cache ||= Cache.new(self.cache_file)
    end
    
    def cache_file
      @cache_file ||= File.join(RAILS_ROOT, 'tmp', 'cache', 'milkshake.cache')
    end
    
    def persist!
      cache.persist!
    end
  end
  
end
