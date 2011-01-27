module Milkshake
  
  RAILS_VERSION = "2.3.4"
  
  require 'fileutils'
  require 'digest/sha1'

  require 'milkshake/version'
  
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
  end
  
  class << self
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
      @environment ||= Environment.new(self.cache)
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
