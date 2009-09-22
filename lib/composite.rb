
$:.push(File.expand_path(File.dirname(__FILE__))) unless $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'fileutils'
require 'rubygems'

module Composite
  
  autoload :DependencyResolver, 'composite/dependency_resolver'
  autoload :Environment,        'composite/environment'
  autoload :Validator,          'composite/validator'
  autoload :Template,           'composite/template'
  autoload :Extender,           'composite/extender'
  autoload :Linker,             'composite/linker'
  autoload :Loader,             'composite/loader'
  autoload :Cache,              'composite/cache'
  autoload :App,                'composite/app'
  
  module RailsExtentions
    autoload :Configuration, 'composite/rails_extentions/configuration'
    autoload :Initializer,   'composite/rails_extentions/initializer'
    autoload :Migrator,      'composite/rails_extentions/migrations'
    autoload :GemBoot,       'composite/rails_extentions/boot'
    autoload :VendorBoot,    'composite/rails_extentions/boot'
  end
  
  module Utils
    autoload :CompositeMethod, 'composite/utils/composite_methods'
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
      self.configuration_file ||= File.join(RAILS_ROOT, 'config', 'composite.yml')
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
      self.cache_file ||= File.join(RAILS_ROOT, 'tmp', 'composite.cache')
      @cache ||= Cache.new(self.cache_file)
    end
    
    def persist!
      cache.persist!
    end
  end
  
end
