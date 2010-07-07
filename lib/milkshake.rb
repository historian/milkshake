require 'fileutils'

module Milkshake
  
  require 'milkshake/version'
  require 'milkshake/rails_version'
  
  require 'milkshake/dependency_resolver'
  require 'milkshake/environment'
  require 'milkshake/validator'
  require 'milkshake/extender'
  require 'milkshake/linker'
  require 'milkshake/loader'
  require 'milkshake/cache'
  
  module RailsExtentions
    require 'milkshake/rails_extentions/configuration'
    require 'milkshake/rails_extentions/initializer'
    require 'milkshake/rails_extentions/migrations'
    require 'milkshake/rails_extentions/boot'
    require 'milkshake/rails_extentions/boot'
  end
  
  module RubygemsExtentions
    require 'milkshake/rubygems_extentions/specification'
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
