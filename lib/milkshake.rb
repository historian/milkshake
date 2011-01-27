module Milkshake

  RAILS_VERSION = "2.3.4"

  require 'fileutils'
  require 'digest/sha1'

  require 'milkshake/version'

  require 'milkshake/environment'
  require 'milkshake/extender'
  require 'milkshake/loader'

  module RailsExtentions
    require 'milkshake/rails_extentions/configuration'
    require 'milkshake/rails_extentions/initializer'
    require 'milkshake/rails_extentions/migrations'
    require 'milkshake/rails_extentions/boot'
  end

  class << self

    def load!
      environment
      loader
      extender
    end

    def environment
      @environment ||= Environment.new
    end

    def loader
      @loader ||= Loader.new(self.environment)
    end

    def extender
      @extender ||= Extender.new
    end

  end

end
