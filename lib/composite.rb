
$:.push(File.expand_path(File.dirname(__FILE__))) unless $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'fileutils'
require 'rubygems'

module Composite
  
  autoload :Environment, 'composite/environment'
  autoload :Validator,   'composite/validator'
  autoload :Extender,    'composite/extender'
  autoload :Linker,      'composite/linker'
  autoload :Loader,      'composite/loader'
  autoload :App,         'composite/app'
  
  module RailsExtentions
    autoload :Configuration, 'composite/rails_extentions/configuration'
    autoload :Initializer,   'composite/rails_extentions/initializer'
    autoload :Migrator,      'composite/rails_extentions/migrations'
    autoload :GemBoot,       'composite/rails_extentions/boot'
    autoload :VendorBoot,    'composite/rails_extentions/boot'
  end
  
  class << self
    attr_accessor :configuration_file
    attr_accessor :validation_file
    
    def environment
      self.configuration_file ||= File.join(RAILS_ROOT, 'config', 'composite.yml')
      @environment ||= Environment.load(self.configuration_file)
    end
    
    def validator
      self.validation_file ||= File.join(RAILS_ROOT, 'tmp', 'composite_version.yml')
      @validator ||= Validator.new(self.environment, self.validation_file)
    end
    
    def loader
      @loader ||= Loader.new(self.environment)
    end
    
    def linker
      @linker ||= Linker.new(self.environment, self.validator)
    end
    
    def extender
      @extender ||= Extender.new(self.environment)
    end
  end
  
end
